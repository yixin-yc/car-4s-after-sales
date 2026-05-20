package com.car4s.config;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
public class DateConverter implements Converter<String, Date> {

    private static final List<String> DATE_FORMATS = new ArrayList<>();

    static {
        // 添加所有支持的日期格式
        DATE_FORMATS.add("yyyy-MM-dd");                    // 2026-03-13
        DATE_FORMATS.add("yyyy/MM/dd");                    // 2026/03/13
        DATE_FORMATS.add("yyyy-MM-dd HH:mm");              // 2026-03-13 11:00
        DATE_FORMATS.add("yyyy-MM-dd HH:mm:ss");           // 2026-03-13 11:00:00
        DATE_FORMATS.add("yyyy-MM-dd'T'HH:mm");            // 2026-03-13T11:00 (HTML5格式)
        DATE_FORMATS.add("yyyy-MM-dd'T'HH:mm:ss");         // 2026-03-13T11:00:00
        DATE_FORMATS.add("yyyy-MM-dd'T'HH:mm:ss.SSS");     // 2026-03-13T11:00:00.000
    }

    @Override
    public Date convert(String source) {
        if (source == null || source.trim().isEmpty()) {
            return null;
        }

        String trimmed = source.trim();
        System.out.println("正在转换日期: " + trimmed); // 添加日志便于调试

        for (String format : DATE_FORMATS) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                sdf.setLenient(false);
                Date result = sdf.parse(trimmed);
                System.out.println("转换成功！使用格式: " + format + " -> " + result);
                return result;
            } catch (ParseException ignored) {
                // 继续尝试下一个格式
            }
        }

        throw new IllegalArgumentException("日期格式错误: " + source + ", 支持的格式: " + DATE_FORMATS);
    }
}