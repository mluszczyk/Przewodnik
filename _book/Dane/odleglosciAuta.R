library(PogromcyDanych)
library(dplyr)

marki <- auta2012 %>%
  filter(Marka %in% c("Volkswagen", "Volvo", "Audi", "Mazda", "Peugeot", "Opel", "Renault", "Citroen", "BMW")) %>%
  group_by(Marka, Model) %>%
  summarise(Nazwa = unique(paste(Marka, Model)),
            n = n(), 
            Cena = median(Cena.w.PLN, na.rm=TRUE),
            Przebieg = median(Przebieg.w.km, na.rm=TRUE),
            Pojemnosc = median(Pojemnosc.skokowa, na.rm=TRUE),
            KM = median(KM, na.rm=TRUE),
            diesle = round(100*mean(Rodzaj.paliwa == "olej napedowy (diesel)"),1)) %>%
  ungroup() %>%
  filter(n > 500) %>%
  dplyr::select(-Marka, -Model) %>%
  as.data.frame()

rownames(marki) <- marki[,1]
marki <- marki[,c(-1, -2)]

biplot(prcomp(marki, center = TRUE, scale. = TRUE))


PCbiplot <- function(PC, x="PC1", y="PC2") {
  # PC being a prcomp object
  data <- data.frame(obsnames=row.names(PC$x), PC$x)
  plot <- ggplot(data, aes_string(x=x, y=y)) + geom_text(alpha=.4, size=3, aes(label=obsnames))
  plot <- plot +
   geom_hline(aes(yintercept=0), size=.2) +
   geom_vline(aes(xintercept=0), size=.2)
  datapc <- data.frame(varnames=rownames(PC$rotation), PC$rotation)
  mult <- min(
    (max(data[,y]) - min(data[,y])/(max(datapc[,y])-min(datapc[,y]))),
    (max(data[,x]) - min(data[,x])/(max(datapc[,x])-min(datapc[,x])))
  )
  datapc <- transform(datapc,
                      v1 = .7 * mult * (get(x)),
                      v2 = .7 * mult * (get(y))
  )
  plot <- plot + coord_equal() + geom_text(data=datapc, aes(x=v1, y=v2, label=varnames), size = 5, vjust=1, color="red")
  plot <- plot + geom_segment(data=datapc, aes(x=0, y=0, xend=v1, yend=v2), arrow=arrow(length=unit(0.2,"cm")), alpha=0.75, color="red")
  plot
}

fit <- prcomp(marki, scale=T)
PCbiplot(fit)
