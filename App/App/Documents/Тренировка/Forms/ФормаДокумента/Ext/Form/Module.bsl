﻿
&НаКлиенте
Процедура УпражненияВыполненоПриИзменении(Элемент)
	
	Если Элементы.Упражнения.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Упражнения.ТекущиеДанные.Выполнено Тогда
		ПараметрыФормы = Новый Структура("Упражнение",Элементы.Упражнения.ТекущиеДанные.Упражнение);
		ОткрытьФорму("Обработка.ВыполнениеУпражнения.Форма.Форма", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОкончанияУпражнения" Тогда
		ЗаполнитьТаблицуУпражнений(Параметр);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуУпражнений(Параметр)
	
	ПараметрыОтбора = Новый Структура("Упражнение",Параметр.Упражнение);
	МассПоиска = Объект.Упражнения.НайтиСтроки(ПараметрыОтбора);
	
	Объект.ПродолжительностьТренировки =  Объект.ПродолжительностьТренировки + Параметр.ВремяВыполнения; 
	
	Для Каждого ТекЭл Из МассПоиска Цикл		
		ТекЭл.КоличествоПодходов = Параметр.КоличествоПодходов;
		ТекЭл.ЧислоПовторений = Параметр.ЧислоПовторений;
		ТекЭл.Вес = Параметр.Вес;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьМестоположение(Команда)
	
	ОпределитьТекущиеГеокоординаты(Объект.МестоТренировки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьТекущиеГеокоординаты(ТекущееМестоположение) Экспорт

    #Если МобильноеПриложениеКлиент Тогда

        ТекущийПровайдер = "gps";
        Попытка
            ДМ = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(ТекущийПровайдер);
        Исключение
            ДМ = Неопределено;
        КонецПопытки;

        Если ДМ = Неопределено Тогда
            ТекущийПровайдер = "network";
            Попытка
                ДМ = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(ТекущийПровайдер);
           Исключение
                ДМ = Неопределено;
            КонецПопытки;
        КонецЕсли;

        Если ДМ = Неопределено Тогда
            Возврат;
        КонецЕсли;

        Если ТекущаяДата() - МестноеВремя(ДМ.Дата) > 300 Тогда
            СредстваГеопозиционирования.ОбновитьМестоположение(ТекущийПровайдер, 5);
            ДМ = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(ТекущийПровайдер);
        КонецЕсли;

        ДА = ПолучитьАдресПоМестоположению(ДМ.Координаты);
        Если ДА = Неопределено Тогда
            ТекущееМестоположение =  "Lat: " + ДМ.Координаты.Широта + ", Lon: " + ДМ.Координаты.Долгота;
        Иначе
            ТекущееМестоположение = СтрЗаменить(ДА.Представление, Символы.ПС, ", ");
        КонецЕсли;

        ТекущееМестоположение = ТекущееМестоположение + "Date: " + МестноеВремя(ДМ.Дата) + ", Provider: " + ТекущийПровайдер;
        	
	#Иначе	
		
    #КонецЕсли

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.УпражненияВыполнено.Видимость = Ложь;
		Элементы.УпражненияУпражнение1.Видимость = Истина;
		Элементы.УпражненияУпражнение.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Дата") Тогда
		Объект.Дата = Параметры.Дата;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УпражненияУпражнение1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Упражнения.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.Упражнения.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура("Упражнение,КоличествоПодходов,ЧислоПовторений,Вес",ТекДанные.Упражнение,ТекДанные.КоличествоПодходов,ТекДанные.ЧислоПовторений,ТекДанные.Вес);
	ОткрытьФорму("Документ.Тренировка.Форма.ФормаПосмотраУпражнений", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыОтбора = Новый Структура("Выполнено",Ложь);
	МасПоиска = ТекущийОбъект.Упражнения.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого ТекЭл Из МасПоиска Цикл
			ТекущийОбъект.Упражнения.Удалить(ТекЭл);
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновлениеФормы");
	
КонецПроцедуры
