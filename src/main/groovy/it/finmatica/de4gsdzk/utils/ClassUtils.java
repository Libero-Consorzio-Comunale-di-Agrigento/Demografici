package it.finmatica.de4gsdzk.utils;

import it.finmatica.ad4.hibernate.UtenteIns;
import it.finmatica.ad4.hibernate.UtenteUpd;
import it.finmatica.de4gsdzk.annotations.Label;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.JoinColumn;
import javax.persistence.Version;
import javax.validation.constraints.NotNull;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.LinkedList;
import java.util.List;

public class ClassUtils {

    public static class ClassField {

        public Object object;
        public Class type;
        public Field field;

        public ClassField(Object object, Class type, Field field) {
            this.object = object;
            this.type = type;
            this.field = field;
        }

        public String sName() {
            return field.getName();
        }

        public boolean isNull() throws Exception {
            return get()==null;
        }

        public boolean isEmpty() throws Exception {
            Object val = get();
            return val==null || val.equals("");
        }

        public boolean isBoilerPlate() {
            return field.isAnnotationPresent(Version.class) ||
                field.isAnnotationPresent(GeneratedValue.class) ||
                    (field.getModifiers() & Modifier.STATIC)>0;
        }

        public boolean isRequired() {

            if (field.isAnnotationPresent(CreationTimestamp.class) || field.isAnnotationPresent(UpdateTimestamp.class)) {
                return false;
            }

            if (field.isAnnotationPresent(UtenteIns.class) || field.isAnnotationPresent(UtenteUpd.class)) {
                return false;
            }

            boolean ret = field.isAnnotationPresent(NotNull.class);
            if (!ret && field.isAnnotationPresent(Column.class)) {
                ret = !field.getAnnotation(Column.class).nullable();
            }
            if (!ret && field.isAnnotationPresent(JoinColumn.class)) {
                ret = !field.getAnnotation(JoinColumn.class).nullable();
            }

            return ret;
        }

        public String getLabel() {
            if (field.isAnnotationPresent(Label.class)) {
                return field.getAnnotation(Label.class).value();
            }
            return fromCamelCase(field.getName());
        }

        @SuppressWarnings("unchecked")
        public Object get() throws Exception {
            return type.getMethod("get" + firstUpperCase(field.getName())).invoke(object);
        }

        @SuppressWarnings("unchecked")
        public void set(Object value) {
            try {
                type.getMethod("set" + firstUpperCase(field.getName()), field.getType()).invoke(object, value);
            } catch(Exception e) {
                //log.error("Errore set"  + firstUpperCase(field.getName()), e)
            }
        }

        private static String firstUpperCase(String s) {
            return String.valueOf(s.charAt(0)).toUpperCase() + s.substring(1);
        }

        private static String fromCamelCase(String s) {
            return firstUpperCase(s.replaceAll("([A-Z])", " $1"));
        }

    }

    public static List<ClassField> getAllFields(Object object) {
        return getAllFields(object, object.getClass(), new LinkedList<ClassField>());
    }

    private static List<ClassField> getAllFields(Object object, Class<?> type, List<ClassField> fields) {
        if (type.getSuperclass()!=null) {
            getAllFields(object, type.getSuperclass(), fields);
        }
        for (Field it : type.getDeclaredFields()) {
            fields.add(new ClassField(object, type, it));
        }
        return fields;
    }

}
