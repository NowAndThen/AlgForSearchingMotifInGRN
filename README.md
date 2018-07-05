# AlgForSearchingMotifInGRN
Данный алгоритм находит мотив и его представителей в GRN (Gene regulatory network).
Алгоритм основан на Self-organizing neural network (SONN), алгоритм SONN реализован в файле SONN.py.
Для тестирования программы использовались тестовые данные, сгенерировать их можно вызвав функцию из модуля 
GeneratorOfDate.py
```
get_test_date(_n, _treasure, _length_seq, _len_motif, count)
#_n - количество последовательностей.
#_treasure - количество генов.
#_length_seq - длина каждой последовательности.
#_len_motif - длина мотива.
#_count - количество генов в обозреваемом множестве.
```

Основной алгоритм реализован в Alg.py.
В котором нужно указать путь к тестовым данным, т.е переменную path. 
