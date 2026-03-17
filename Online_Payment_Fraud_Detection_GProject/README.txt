# Fraud Detection Project – Python, SQL, Power BI

## 📌 Business Problem
Fraudulent transactions are rare but extremely costly for financial institutions.  
Banks need robust systems to detect suspicious activity in real time, especially in **transfer** and **cash‑out** transactions.  
This project simulates a fraud detection workflow using Kaggle’s financial transactions dataset, demonstrating how data analytics and machine learning can reduce fraud risk.

---

## 📊 Dataset
- **Source**: Kaggle – Online Payment Fraud Detection Dataset  
- **Size**: ~6 million transactions  
- **Key Columns**:
  - `step`: Time unit (1 step = 1 hour)  
  - `type`: Transaction type (transfer, cash‑out, payment, etc.)  
  - `amount`: Transaction amount  
  - `nameOrig`: Customer initiating transaction  
  - `oldbalanceOrg` / `newbalanceOrg`: Sender’s balance before/after  
  - `nameDest`: Recipient account  
  - `oldbalanceDest` / `newbalanceDest`: Recipient’s balance before/after  
  - `isFraud`: Fraud flag (1 = fraud, 0 = legitimate)

---

## ⚙️ Methodology

### 1. Data Preparation (SQL)
- Imported dataset into SQL for cleaning and aggregation.  
- Created engineered features:
  - `balanceDiffOrig` = oldbalanceOrg – newbalanceOrg  
  - `balanceDiffDest` = newbalanceDest – oldbalanceDest  
  - `hourOfDay` = step % 24  
  - Transaction amount buckets (Small / Medium / Large).  
- Generated summary tables: fraud by type, amount, time, and anomalies.

### 2. Exploratory Data Analysis (Python)
- Fraud distribution across transaction types.  
- Fraud rate by transaction amount and time of day.  
- Balance anomalies where amounts don’t reconcile.  

### 3. Modeling (Python)
- Logistic Regression (baseline, interpretable).  
- Random Forest (advanced, higher accuracy).  
- Evaluation metrics: Precision, Recall, F1 Score, ROC‑AUC.  
- Achieved **ROC‑AUC score of 0.96** with Random Forest.  

### 4. Visualization (Power BI + Excel)
- KPI cards: total transactions, fraud cases, fraud rate, average transaction amount, average fraud amount.  
- Bar chart: fraud by transaction type.  
- Column chart: fraud by amount bucket.  
- Line chart: fraud by hour of day.  
- Tables: balance anomalies, top fraudulent customers and recipients.  

---

## 📈 Derived Business Insights
- Fraud is concentrated in **transfer** and **cash‑out** transactions.  
- **Large transactions** show the highest fraud rate.  
- Fraud cases cluster at specific **hours/days**, suggesting weak monitoring windows.  
- Certain **customers and recipients** repeatedly appear in fraud cases.  
- Fraudulent transactions often show **balance inconsistencies**, a strong anomaly signal.  
- Overall fraud rate is low (<1%), but **average fraud transaction amount is much higher**, making fraud extremely costly.

---

## 💡 Business Impact
- Strengthen monitoring of **transfer and cash‑out** transactions.  
- Flag **large transactions** for enhanced review.  
- Use **anomaly detection** (balance mismatches, unusual timing) to catch fraud early.  
- Investigate **repeat offenders** (customers/recipients with multiple fraud cases).  
- Prioritize fraud prevention efforts on **high‑value, high‑risk transactions**.

---

## 🚀 Deliverables
- **SQL scripts** for data preparation and aggregation.  
- **Python notebook** for EDA and modeling.  
- **Power BI dashboard** with fraud KPIs and visual insights.  
- **Excel pivot tables** for quick summaries.  
- **README file** (this document) explaining the project end‑to‑end.

---

## 📢 Conclusion
This project demonstrates an **end‑to‑end workflow**:  
Raw data → SQL cleaning → Python modeling → Power BI visualization → Business insights.  

It simulates how banks detect fraud and showcases skills in **SQL, Python, Power BI, and Excel** — making it highly relevant for finance/banking recruiters in Dubai and globally.