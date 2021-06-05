# hse21_H3K4me3_G4_human

## Проект по майнору "Биоинформатика"
### Барчук Ирина, группа 2

#### Выбранные структуры

| Организм | Структура ДНК | Гистоновая метка | Тип клеток | Метка 1 | Метка 2 |
| -------- | ------------- | ---------------- | ---------- | ------- | ------- |
| Human (hg19) | G4_seq_Li_K | H3K4me3 | H1 | [ENCFF883IEF](https://www.encodeproject.org/files/ENCFF883IEF/) | [ENCFF881GRS](https://www.encodeproject.org/files/ENCFF881GRS/) |

#### Анализ пиков гистоновой метки
##### Подготовка данных

Для последующей работы на кластер в личную директорию iabarchuk/project были сохранены архивы с .bed-файлами с данными. При распаковке архивов были оставлены только первые 5 столбцов данных:

```bash
wget https://www.encodeproject.org/files/ENCFF883IEF/@@download/ENCFF883IEF.bed.gz
zcat ENCFF883IEF.bed.gz  |  cut -f1-5 > ENCFF883IEF.hg38.bed

wget https://www.encodeproject.org/files/ENCFF881GRS/@@download/ENCFF881GRS.bed.gz
zcat ENCFF881GRS.bed.gz  |  cut -f1-5 > ENCFF881GRS.hg38.bed
```

Далее координаты ChIP-seq пиков были приведены к 19 версии генома:

```bash
wget https://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz

liftOver   ENCFF883IEF.hg38.bed   hg38ToHg19.over.chain.gz   ENCFF883IEF.hg19.bed   ENCFF883IEF.unmapped.bed
liftOver   ENCFF881GRS.hg38.bed   hg38ToHg19.over.chain.gz   ENCFF881GRS.hg19.bed   ENCFF881GRS.unmapped.bed
```

Затем с помощью команды `scp -P` все полученные файлы были загружены на ПК для дальнейшей работы.

##### Построение гистограмм длин участков

С помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/length_hists.R) на языке программирования R были получены гистограммы длин участков для каждого эксперимента до и после конвертации к нужной версии генома. Были получены следующие результаты:

![len_hist_ENCFF883IEF_hg19](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/len_hist_ENCFF883IEF_hg19.png)

![len_hist_ENCFF881GRS_hg19](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/len_hist_ENCFF881GRS_hg19.png)

##### Фильтрация пиков

С помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/peaks_filter.R) на языке программирования R были отфильтрованы пики длиной более 5000. Были получены следующие результаты:

![filter_peaks_ENCFF883IEF_hg19_filtered_hist](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/filter_peaks_ENCFF883IEF_hg19_filtered_hist.png)

![filter_peaks_ENCFF881GRS_hg19_filtered_hist](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/filter_peaks_ENCFF881GRS_hg19_filtered_hist.png)

##### Расположение пиков

С помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/chip_seeker.R) на языке программирования R были построены графики расположения пиков гистоновых меток относительно аннотированных генов. Были получены следующие результаты:

![chip_seeker.ENCFF883IEF.hg19.filtered.plotAnnoPie](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/chip_seeker.ENCFF883IEF.hg19.filtered.plotAnnoPie.png)

![chip_seeker.ENCFF881GRS.hg19.filtered.plotAnnoPie](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/chip_seeker.ENCFF881GRS.hg19.filtered.plotAnnoPie.png)

##### Объединение файлов

Отсортированные файлы были загружены на кластер в личную директорию iabarchuk/project, отсортированы и объединены с помощью bedtools:

```bash
wget https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF881GRS.hg19.filtered.bed
wget https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF883IEF.hg19.filtered.bed

cat  *.filtered.bed  |   sort -k1,1 -k2,2n   |   bedtools merge   >  merged.hg19.bed 
```

Затем с помощью команды `scp -P` полученный файл был загружен на ПК для дальнейшей работы.