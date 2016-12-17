﻿#Использовать ".."
#Использовать asserts
#Использовать tempfiles

Перем юТест;
Перем УправлениеКонфигуратором;

Процедура Инициализация()
	
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором;
	Лог = Логирование.ПолучитьЛог("oscript.lib.v8runner");
	Лог.УстановитьУровень(УровниЛога.Отладка);

КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	СписокТестов.Добавить("ТестДолжен_ИзменитьКаталогСборки");
	СписокТестов.Добавить("ТестДолжен_СоздатьВременнуюБазу");
	СписокТестов.Добавить("ТестДолжен_ПроверитьНазначениеПутиКПлатформе");
	СписокТестов.Добавить("ТестДолжен_ПроверитьУстановкуЯзыкаИнтерфейса");
	СписокТестов.Добавить("ТестДолжен_СоздатьХранилищеКонфигурации");
	СписокТестов.Добавить("ТестДолжен_ПроверитьСозданиеФайловПоставки");
	
	Возврат СписокТестов;
	
КонецФункции

Процедура ТестДолжен_ИзменитьКаталогСборки() Экспорт
	
	ПоУмолчанию = ТекущийКаталог();
	Утверждения.ПроверитьРавенство(УправлениеКонфигуратором.КаталогСборки(), ПоУмолчанию, "По умолчанию каталог сборки должен совпадать с текущим каталогом");
	
	СтароеЗначение = УправлениеКонфигуратором.КаталогСборки(КаталогВременныхФайлов());
	Утверждения.ПроверитьРавенство(СтароеЗначение, ПоУмолчанию, "Предыдущее значение каталога должно возвращяться при его смене");
	Утверждения.ПроверитьРавенство(УправлениеКонфигуратором.КаталогСборки(), КаталогВременныхФайлов(), "Каталог сборки должен быть изменен");
	
КонецПроцедуры

Процедура ТестДолжен_СоздатьВременнуюБазу() Экспорт
	
	Если УправлениеКонфигуратором.ВременнаяБазаСуществует() Тогда
		УдалитьФайлы(УправлениеКонфигуратором.ПутьКВременнойБазе());
	КонецЕсли;
	
	Утверждения.ПроверитьЛожь(УправлениеКонфигуратором.ВременнаяБазаСуществует(), "Временной базы не должно быть в каталоге <"+УправлениеКонфигуратором.ПутьКВременнойБазе()+">");
	УправлениеКонфигуратором.СоздатьФайловуюБазу(УправлениеКонфигуратором.ПутьКВременнойБазе());
	Сообщить(УправлениеКонфигуратором.ВыводКоманды());
	Утверждения.ПроверитьИстину(УправлениеКонфигуратором.ВременнаяБазаСуществует(), "Временная база должна существовать");
	УдалитьФайлы(УправлениеКонфигуратором.ПутьКВременнойБазе());
	
КонецПроцедуры


Процедура ТестДолжен_СоздатьХранилищеКонфигурации() Экспорт
	
	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();

	УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);

	КаталогВременногоХранилища = ОбъединитьПути(ВременныйКаталог, "v8r_TempRepository");

	ФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0\1Cv8.cf");
		
	
	УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ФайлКонфигурации);
	// по идеи надо проверить что конфигурация загружена.
	// Вопрос как?
	УправлениеКонфигуратором.СоздатьФайловоеХранилищеКонфигурации(
									КаталогВременногоХранилища,
									"Администратор");
	Утверждения.ПроверитьИстину(УправлениеКонфигуратором.ХранилищеКонфигурацииСуществует(КаталогВременногоХранилища), "Временное хранилище конфигурации должно существовать");
	ВременныеФайлы.Удалить() 
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьСозданиеФайловПоставки() Экспорт
	
	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();

	УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);

	КаталогПоставки = ОбъединитьПути(ВременныйКаталог, "v8r_TempDitr");
	
	ПутьФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0\1Cv8.cf");
	
	НомерВерсииВыпуска = "1.0";
	
	ПутьФайлПредыдущейПоставки =  ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "0.9\1Cv8.cf"); 

	ПутьФайлПолнойПоставки = ОбъединитьПути(КаталогПоставки, НомерВерсииВыпуска +".cf");
	
	ПутьФайлаПоставкиОбноления = ОбъединитьПути(КаталогПоставки, НомерВерсииВыпуска+".cfu");
	
	МассивФайловПредыдущейПоставки = новый Массив;
	МассивФайловПредыдущейПоставки.Добавить(ПутьФайлПредыдущейПоставки);

	УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ПутьФайлКонфигурации, Истина);
	
	УправлениеКонфигуратором.СоздатьФайлыПоставки(ПутьФайлПолнойПоставки,
												ПутьФайлаПоставкиОбноления,
												МассивФайловПредыдущейПоставки);
	
	Утверждения.ПроверитьИстину(ФайлСуществует(ПутьФайлПолнойПоставки), "Файл полной поставки конфигурации должен существовать");
	Утверждения.ПроверитьИстину(ФайлСуществует(ПутьФайлаПоставкиОбноления), "Файл частичной поставки конфигурации должен существовать");
	
	ВременныеФайлы.Удалить(); 
	
КонецПроцедуры




Процедура ТестДолжен_ПроверитьНазначениеПутиКПлатформе() Экспорт
	
	ПутьПоУмолчанию = УправлениеКонфигуратором.ПолучитьПутьКВерсииПлатформы("8.3");
	Утверждения.ПроверитьЛожь(ПустаяСтрока(ПутьПоУмолчанию));
	Утверждения.ПроверитьРавенство(ПутьПоУмолчанию, УправлениеКонфигуратором.ПутьКПлатформе1С());
	
	НовыйПуть = "тратата";
	Попытка
		УправлениеКонфигуратором.ПутьКПлатформе1С(НовыйПуть);
	Исключение
		Возврат;
	КонецПопытки;
	
	ВызватьИсключение "Не было выброшено исключение при попытке установить неверный путь";
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьУстановкуЯзыкаИнтерфейса() Экспорт
	
	ПоУмолчанию = "en";
	УправлениеКонфигуратором.УстановитьКодЯзыка(ПоУмолчанию);
	
	МассивПараметров = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	Утверждения.ПроверитьБольшеИлиРавно(МассивПараметров.Найти("/L"+ПоУмолчанию), 0, "Массив параметров запуска должен содержать локализацию  /L"+ПоУмолчанию + " строка:"+Строка(МассивПараметров));
	Утверждения.ПроверитьБольшеИлиРавно(МассивПараметров.Найти("/VL"+ПоУмолчанию), 0, "Массив запуска должен содержать локализацию сеанаса /VL"+ПоУмолчанию + " строка:"+Строка(МассивПараметров));
	
КонецПроцедуры

// Проверяет существование каталога
//
// Параметры:
//   Путь - Проверяемый путь
//
//  Возвращаемое значение:
//   Булево   - Истина, если каталог существует
//
Функция КаталогСуществует(Знач Путь) Экспорт
  
    Объект = Новый Файл(Путь);

    Возврат Объект.Существует() и Объект.ЭтоКаталог();
 
КонецФункции // КаталогСуществует()

// Проверяет существование файла
//
// Параметры:
//   Путь - Проверяемый путь
//
//  Возвращаемое значение:
//   Булево   - Истина, если файл существует
//
Функция ФайлСуществует(Знач Путь) Экспорт

    Объект = Новый Файл(Путь);

    Возврат Объект.Существует() и Объект.ЭтоФайл();

КонецФункции // ФайлСуществует()

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация


Инициализация();
