package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j
import org.hibernate.Hibernate
import org.hibernate.proxy.HibernateProxyHelper
import org.springframework.data.annotation.Id

import javax.persistence.EmbeddedId
import java.lang.reflect.Field
import java.lang.reflect.Modifier
import java.security.MessageDigest

@Slf4j
class HashUtils {

    static String computeStateHash(Object obj) {
        if (!obj) return ''

        String values = formatValue(obj)

        return sha256(values)
    }

    private static String formatValue(Object obj, Set<Object> visited = new HashSet<>()) {
        if (obj == null) {
            return "null"
        }
        if (obj instanceof Exception) {
            return "[Exception: ${obj.getClass().simpleName} ${obj.getMessage()}]"
        }
        if (!Hibernate.isInitialized(obj)) {
            String className = HibernateProxyHelper.getClassWithoutInitializingProxy(obj)
            return "[Uninitialized Proxy: ${className}, ${extractIdInfo(obj)}]"
        }

        if (visited.contains(obj)) {
            return "[Cyclic Reference]"
        }
        visited.add(obj)

        if (obj instanceof Number || obj instanceof String || obj instanceof Boolean || obj.getClass().isEnum()) {
            return obj.toString()
        }

        if (obj instanceof Collection) {
            return obj.collect { formatValue(it, visited) }.join(',')
        }

        if (obj.getClass().isArray()) {
            return Arrays.asList(obj).collect { formatValue(it, visited) }.join(',')
        }

        if (obj instanceof Map) {
            return obj.collect { k, v -> "${formatValue(k, visited)}:${formatValue(v, visited)}" }.join(',')
        }

        def result = []
        obj.metaClass.properties.each { prop ->
            def key = prop.name
            if (!['class', 'metaClass'].contains(key) && !isExcludedField(prop.type, key)) {
                def value
                try {
                    value = prop.getProperty(obj)
                } catch (Exception ignored) {
                    value = "[Error reading property]"
                }

                result << "${key}=${formatValue(value, visited)}"
            }
        }

        return "${obj.getClass().simpleName}(${result.join(',')})"
    }

    private static String extractIdInfo(Object obj) {
        if (obj == null) return "null"

        def idParts = []
        def cls = HibernateProxyHelper.getClassWithoutInitializingProxy(obj)

        while (cls != null && cls != Object) {
            cls.declaredFields.each { Field field ->
                field.setAccessible(true)
                if (field.getAnnotation(Id) || field.getAnnotation(EmbeddedId)) {
                    def idValue = field.get(obj)
                    if (field.getAnnotation(EmbeddedId)) {
                        idValue?.class?.declaredFields?.each { Field subField ->
                            subField.setAccessible(true)
                            idParts << "${subField.name}=${subField.get(idValue)}"
                        }
                    } else {
                        idParts << "${field.name}=${idValue}"
                    }
                }
            }
            cls = cls.getSuperclass()
        }

        return idParts ? idParts.join(', ') : "no-id"
    }

    private static boolean isExcludedField(Class clazz, String fieldName) {
        try {
            // Get metaProperty from Groovy's metaClass
            def metaProp = clazz.metaClass.getMetaProperty(fieldName)
            if (metaProp == null) {
                // Property not found, so can't exclude by field modifiers
                return false
            }

            // Try to get the actual field behind the property if it exists
            Field field = null
            try {
                field = clazz.getDeclaredField(fieldName)
            } catch (NoSuchFieldException ignored) {
                // No field backing the property, so probably a dynamic property or getter-only
            }

            if (field != null) {
                // Exclude if transient or static or UtenteUpd
                return Modifier.isTransient(field.modifiers) || Modifier.isStatic(field.modifiers)
            } else {
                // No backing field - check if there's a getter method, and exclude if it is static
                def getter = clazz.metaClass.getMetaMethod("get" + fieldName.capitalize())
                def isGetter = clazz.metaClass.getMetaMethod("is" + fieldName.capitalize())

                def method = getter ?: isGetter
                if (method != null) {
                    return Modifier.isStatic(method.getModifiers())
                }
            }

            // Otherwise, do not exclude
            return false
        } catch (Exception e) {
            log.error(e.message, e)
            return false
        }
    }


    private static String sha256(String input) {
        MessageDigest digest = MessageDigest.getInstance("SHA-256")
        byte[] hashBytes = digest.digest(input.bytes)
        return hashBytes.encodeHex().toString()
    }
}

