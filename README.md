# DataAnalysisRep_Thomspon
## 📘 Project Overview

This project replicates selected analyses and visualizations from the article:

**"Household Inequality, Common Formation, and Land Tenure in Classic Period Lowland Maya Society"**  
*Thompson, A.E., & Prufer, K.M. (2021), Journal of Archaeological Method and Theory, 28:1276–1313.*  
[DOI: 10.1007/s10816-020-09505-3](https://doi.org/10.1007/s10816-020-09505-3)

The study explores how access to social and environmental resources shaped household settlement patterns and inequality at the Classic Maya sites of **Ix Kuku’il** and **Uxbenká**. It compares spatial patterns using Ideal Free vs. Ideal Despotic Distribution models from human behavioral ecology.

---

## 🧪 Replicated Analyses

This project reproduces the following components from the original study:

- **Figure 7**: Radiocarbon date sums using OxCal  
- **Figure 9**: Suitability variable trends over time (means and boxplots)  
- **Figure 10**: Frequency bar charts for soil, bedrock, and erosion  
- **Table 6**: Kruskal-Wallis tests for five key variables

Each figure was recreated using R (and OxCal for Bayesian modeling), with attention to data wrangling, visualization design, and statistical reproducibility.

---

## 📁 Project Structure

- `Data/`: Includes Excel data files (e.g., MOESM13.xlsx, MOESM14.xlsx, MOESM9.xlsx)
- `Images/`: Stores exported figures (e.g., fig9_patchwork.png, fig10.png, table6.png)
- `Thompson_Prufer_Replication.Rmd`: Main R Markdown document containing the full analysis
- `README.md`: This file

---

## ⚠️ Challenges

- Transparent image overlays (for Figure 7) were difficult to align using R, as the original was built in Inkscape.
- Bar plot sizing and data reshaping for faceting required manual adjustments to improve readability and match the original formatting.

---

## ✅ Learning Outcomes

This project reinforced skills in:

- Data cleaning and transformation (dplyr, tidyr)
- Visualization (ggplot2, ggpubr, patchwork)
- Non-parametric statistical testing (Kruskal-Wallis)
- Integration of archaeological data and spatial-temporal modeling tools like OxCal

It successfully applied classroom knowledge to a meaningful archaeological context, deepening technical confidence and research insight.

---

## 📌 Citation

If referencing this project or reusing figures, please cite:

**Thompson, A.E., & Prufer, K.M. (2021)**  
*Household Inequality, Common Formation, and Land Tenure in Classic Period Lowland Maya Society*  
*Journal of Archaeological Method and Theory, 28:1276–1313*  
[DOI: 10.1007/s10816-020-09505-3](https://doi.org/10.1007/s10816-020-09505-3)

---
