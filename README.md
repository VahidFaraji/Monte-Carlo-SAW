# Monte Carlo and Empirical Methods - Self-Avoiding Walks

This repository contains MATLAB implementations and a report on **Monte Carlo methods** for estimating **self-avoiding walks (SAWs)** in `Z^d`. The project explores different **importance sampling techniques** to estimate the number of self-avoiding walks and applies **sequential importance sampling with resampling (SISR)** to improve estimation accuracy.

## 📜 Project Overview
Self-avoiding walks (SAWs) are used in various fields, including **statistical physics, combinatorics, and polymer science**. The primary goal of this project is to **estimate the number of SAWs** of length `n` in `Z^d` using Monte Carlo techniques.

The project is divided into the following **key tasks**:
- **Basic Monte Carlo estimation** using naive importance sampling.
- **Improved importance sampling methods** with self-avoiding constraints.
- **Sequential importance sampling with resampling (SISR)** for more accurate estimations.
- **Statistical analysis** of estimated SAWs.
- **Generalization to higher dimensions (`d = 3, 6, 12, 24`)**.

## 📂 Repository Structure

| File                 | Description |
|----------------------|-------------|
| `HA2_Monte_Carlo.pdf` | The full project report explaining the methodology, results, and analysis. |
| `Part_a_3.m` | Implements a **naive Sequential Importance Sampling (SIS) method** for estimating SAWs in `Z²`. |
| `Part_a_4.m` | Uses an **improved SIS method** that ensures only self-avoiding walks are sampled. |
| `Part_a_5.m` | Implements **Sequential Importance Sampling with Resampling (SISR)** for better accuracy. |
| `Part_a_6.m` | **Statistical analysis**: Runs multiple trials and estimates **growth parameters** (A₂, μ₂, γ₂). |
| `Part_a_9.m` | Generalizes the SAW estimation to **higher dimensions (`d = 3, 6, 12, 24`)**. |

## 🔧 How to Run
To run the simulations, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/VahidFaraji/Monte-Carlo-SAW.git
   cd Monte-Carlo-SAW
