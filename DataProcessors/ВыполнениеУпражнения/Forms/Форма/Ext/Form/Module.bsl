﻿
&НаКлиенте
Процедура ЗапускТаймера(Команда)
		
	ЭтаФорма.Доступность = Ложь;
	
	КоличествоСекунд = ПериодТаймера * 60;
	
	Элементы.Отсчет.МинимальноеЗначение = 0;
	Элементы.Отсчет.МаксимальноеЗначение = КоличествоСекунд;
	Отсчет = 0;
	
	ДатаНачала = ТекущаяДата();
	ДатаОкончания = ДатаНачала + КоличествоСекунд;

	Осталось = НачалоДня(ДатаНачала) + КоличествоСекунд;
	
	ПодключитьОбработчикОжидания("ОтсчетВремени", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтсчетВремени() Экспорт
	
	ТекстСообщения = "Тест";
	
	КоличествоСекунд = ДатаОкончания - ТекущаяДата();
	
	Если КоличествоСекунд >= 0 Тогда
		Отсчет = Элементы.Отсчет.МаксимальноеЗначение - КоличествоСекунд;
		Осталось = НачалоДня(ДатаНачала) + КоличествоСекунд;
		
		ЭтотОбъект.ОбновитьОтображениеДанных();
		
	Иначе
		#Если МобильноеПриложениеКлиент Тогда
			
			Уведомление = Новый ДоставляемоеУведомление;
			Уведомление.Заголовок = "Таймер обратного отсчета";
			Уведомление.Текст = ТекстСообщения;
			Уведомление.ЗвуковоеОповещение = ЗвуковоеОповещение.ПоУмолчанию;
			Уведомление.Наклейка = 1;
			
			ДоставляемыеУведомления.ДобавитьЛокальноеУведомление(Уведомление);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьПолучениеУведомления", ОбщегоНазначенияНаКлиенте);
			
			ДоставляемыеУведомления.ПодключитьОбработчикУведомлений(ОписаниеОповещения);
		
		#Иначе
			
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = ТекстСообщения;
			СообщениеПользователю.Сообщить();
			
		#КонецЕсли

		ЭтаФорма.Доступность = Истина;
		ОтключитьОбработчикОжидания("ОтсчетВремени");
		
		Отсчет = Элементы.Отсчет.МаксимальноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ЧислоПовторений = 0;
	Вес = 0;
	Для Каждого ТекСтрока Из Подходы Цикл
		ЧислоПовторений = ЧислоПовторений + ТекСтрока.ЧислоПовторений;
		Вес = Вес + ТекСтрока.Вес;
	КонецЦикла;
	
	ПарамСтруктура = Новый Структура("КоличествоПодходов,ЧислоПовторений,Вес,Упражнение,ВремяВыполнения", Подходы.Количество(), ЧислоПовторений, Вес, Упражнение, ПериодТаймера*Подходы.Количество());
	
	Оповестить("ОкончанияУпражнения",ПарамСтруктура);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Упражнение") Тогда
		Упражнение = Параметры.Упражнение;
		ПериодТаймера = Упражнение.ВремяВыполнения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьТренировку(Команда)
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры
