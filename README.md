# Отчет о проделанной практической работе с потоками

## Задание

Найдите с помощью алгоритма полного перебора пятибуквенные пароли, соответствующие следующим хэш-значенияи MD5 и SHA-256 и выведите их на экран, сравнив время перебора:

1. 1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad
2. 3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b
3. 74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f
4. 7a68f09bd992671bb3b19a5e70b7827e

Хэш значения могут считываться из файла или непосредственно с консоли (формы для ввода хэш-значения)

## 1. Bruteforce MD5 1 поток

![Bruteforce MD5 1 поток](https://github.com/user-attachments/assets/df6238c9-5b3e-4a00-8034-f65f19beeec7)

## 2. Bruteforce SHA256 12 потоков

![Bruteforce SHA256 12 потоков](https://github.com/user-attachments/assets/2dc080be-b65d-4c2a-97a4-6316447ae88e)

В программе используются потоки (threads) и NSLock для синхронизации доступа к общим ресурсам. Если указать слишком много потоков, производительность не увеличится из-за ограничений ядра процессора. В этом случае потоки будут конкурировать за ресурсы процессора, что может привести к накладным расходам на их переключение контекста.
