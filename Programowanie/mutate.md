# Jak tworzyć nowe kolumny?

Modelowanie czy przetwarzanie danych często wymaga tworzenia nowych zmiennych na bazie istniejących. 
Czasem na podstawie ceny buduje się logarytm ceny (jedna kolumna z jednej kolumny), czasem na podstawie wagi i wzrostu liczy się BMI (jedna zmienna z kilku zmiennych).

Funkcja `mutate()` z pakietu `dplyr` pozwala na wygodne tworzenie dodatkowych kolumn w zbiorze danych na podstawie innych istniejących już kolumn.


Przedstawmy działanie tej funkcji na przykładzie danych `auta2012` o samochodach. w pierwszym przykładzie policzymy wiek auta (a ponieważ przedstawione ogłoszenia pochodzą z 2013 roku to wiek będzie równy 2013 - rok produkcji). 

Kolejny przykład przekształca dwie kolumny w jedną. Na podstawie ceny w PLN oraz informacji czy jest to cena brutto czy netto policzymy odpowiednik ceny brutto dla wszystkich ofert.


```r
library(dplyr)
library(PogromcyDanych)

autaZWiekiem <- mutate(auta2012,
                       Wiek.auta = 2013 - Rok.produkcji)
head(autaZWiekiem[,c("Wiek.auta", "Rok.produkcji")])
```

```
##   Wiek.auta Rok.produkcji
## 1         5          2008
## 2         5          2008
## 3         4          2009
## 4        10          2003
## 5         6          2007
## 6         9          2004
```

```r
autaZCenaBrutto <- mutate(auta2012, 
                          Cena.brutto = Cena.w.PLN * ifelse(Brutto.netto == "brutto", 1, 1.23))
head(autaZCenaBrutto[,c("Cena.brutto", "Cena.w.PLN", "Bruto.netto")])
```

```
## Error in `[.data.frame`(autaZCenaBrutto, , c("Cena.brutto", "Cena.w.PLN", : undefined columns selected
```

Przetwarzanie kolumn może być bardziej złożone i może dotyczyć zmiennych które nie są liczbami. 
Na poniższym przykładzie wykorzystujemy funkcją `grepl()` wyznaczająca wektor wartości TRUE/FALSE w zależności od tego czy w analizowanym napisie występuje określony wzorzec. 

Na podstawie kolumny `Wyposazenie.dodatkowe` wyznaczany binarne zmienne opisujące czy dane auto ma autoalarm, centralny zamek kub klimatyzację.


```r
autaZWyposazeniem <- mutate(auta2012,
         Autoalarm = grepl(pattern = "autoalarm", Wyposazenie.dodatkowe),
         Centralny.zamek = grepl(pattern = "centralny zamek", Wyposazenie.dodatkowe),
         Klimatyzacja = grepl(pattern = "klimatyzacja", Wyposazenie.dodatkowe))
```

