# 🛡️ Anti-Money Laundering (AML) Monitoring System

## 📌 Project Overview
This project demonstrates an **end-to-end AML monitoring pipeline** integrating **SQL, Python, and Power BI** to detect suspicious financial activity in a large-scale transaction dataset (9.5M+ rows, 12 columns).  
The system combines **rule-based detection** with **machine learning anomaly scoring**, and presents results in **interactive dashboards** for compliance teams.

---

## ⚙️ Tech Stack
- **SQL (PostgreSQL)** → Data cleaning, feature engineering, rule-based detection  
- **Python (pandas, scikit-learn, imbalanced-learn, matplotlib, seaborn)** → ML modeling, anomaly detection, risk scoring  
- **Power BI** → Executive dashboards, visual storytelling, compliance insights  

---

## 🗂️ Workflow

### 1. Data Preparation (SQL)
- Cleaned raw transaction data (handled missing values, type mismatches, CSV import errors).  
- Engineered features:
  - Transaction frequency per account  
  - Rolling sums (24-hour transaction totals)  
  - High-risk jurisdiction flags  
- Built percentile queries to identify **95th/99th percentile outliers**.  
- Rule-based suspicious detection (structuring, layering, cash transactions, FATF jurisdictions).

### 2. Machine Learning (Python)
- Connected PostgreSQL data into Python using `psycopg2` and `pandas`.  
- Preprocessed categorical variables with one-hot encoding.  
- Applied models:
  - **Random Forest & Logistic Regression** → supervised classification  
  - **Isolation Forest** → unsupervised anomaly detection  
- Handled class imbalance with **SMOTE oversampling** and **class-weight adjustments**.  
- Evaluated models using **precision, recall, F1-score, ROC-AUC, PR-AUC**.  
- Derived **risk scores** combining SQL rules + ML predictions.

### 3. Visualization (Power BI)
- Built interactive dashboards with multiple pages:
  - **Overview** → KPIs, daily/weekly/monthly transaction trends  
  - **Risk Analysis** → top accounts, risk scores, laundering type distribution  
  - **Suspicious Activity** → flagged transactions, anomaly scatter plots, geographic maps  
  - **Network Analysis** → account clusters, sender-receiver relationships  
- Added slicers for date, currency, location, payment type.  
- Applied conditional formatting (red = suspicious, green = normal).  

---

## 📊 Derived Outcomes
- Identified **high-value transactions** above 95th/99th percentiles.  
- Flagged **structuring and layering patterns** using SQL rules.  
- Detected **rare anomalies** with Isolation Forest, reducing false positives.  
- Produced **risk scores per transaction/account** for compliance prioritization.  
- Delivered **executive-ready dashboards** aligned with FATF AML standards.  

---

## 🚀 Business Impact
- Enables compliance teams to **monitor suspicious activity in real time**.  
- Reduces false positives by combining **rule-based detection with ML anomaly scoring**.  
- Provides transparent documentation of rules, models, and dashboards.  
- Demonstrates **end-to-end data pipeline skills** (SQL → Python → Power BI).  

---

## 📌 Summary
*Developed an AML monitoring pipeline using SQL, Python ML models, and Power BI dashboards to detect suspicious transactions, reduce false positives, and deliver compliance insights aligned with FATF standards.*