📌 Project Overview
This project delivers an end‑to‑end analysis of loan application data using Power BI, focusing on both rejected and accepted datasets. The objective is to demonstrate skills in data cleaning, risk analytics, predictive modeling, and business storytelling relevant to finance and compliance teams.

🔴 Rejected Dataset Analysis
Workflow
- Data Cleaning: Created missingness flags to quantify incomplete fields (Risk Score, Employment Length, State, Loan Title, DTI).
- Missingness Heatmap: Matrix visual with conditional formatting to highlight data quality issues.
- Rejection Trends: Line chart showing monthly rejection volumes, filtered by loan purpose and state.
- Top Rejected Purposes: Bar chart ranking loan categories most often rejected.
- Risk Profiles: Histogram of Debt‑to‑Income ratios and box plots of FICO scores by loan purpose.
Outcomes
- Found high missingness in Risk Score and Employment Length fields.
- Identified seasonal spikes in rejection rates.
- Debt Consolidation and Small Business loans were most frequently rejected.
- Rejected applicants clustered in high DTI and low FICO ranges, confirming risk‑driven rejection.

🟢 Accepted Dataset Analysis
Workflow
- Feature Engineering: Derived FICO midpoint and categorized applicants into score buckets (Poor → Excellent).
- Default Prediction: Modeled default risk using accepted loans with repayment outcomes.
- Model Evaluation: Displayed accuracy, precision, recall, and confusion matrix visuals.
- Business Insights: Compared default rates across loan purposes, states, and employment lengths.
Outcomes
- Higher FICO buckets correlated with lower default rates.
- Small Business and Debt Consolidation loans showed higher default risk.
- Longer employment length improved acceptance and repayment likelihood.
- Predictive model achieved balanced performance, demonstrating value for credit risk assessment.

⚖️ Combined Insights
Workflow
- Built comparison visuals across both datasets:
- FICO Score Comparison: Box plots of accepted vs rejected applicants.
- State‑Level Acceptance vs Rejection: Map visual with dual color scale.
- Loan Purpose Acceptance Rate: 100% stacked bar chart.
Outcomes
- Accepted applicants had higher median FICO scores than rejected ones.
- Certain states showed higher rejection bias, aligning with risk patterns.
- Loan purposes like Home Improvement had higher acceptance rates, while Debt Consolidation faced stricter screening.

🎯 Key Takeaways
- Demonstrated data quality assessment with rejected dataset.
- Built predictive modeling and evaluation with accepted dataset.
- Delivered business‑driven insights by combining both datasets.
- Showcased ability to connect technical analytics with compliance and risk management storytelling.

🚀 Tools & Skills Highlighted
- Power BI: Dashboard design, matrix visuals, conditional formatting, DAX measures.
- SQL/PostgreSQL: Data extraction and preprocessing.
- Data Analytics: Missingness analysis, feature engineering, risk profiling.
- Business Context: Credit risk, loan rejection drivers, compliance insights.
