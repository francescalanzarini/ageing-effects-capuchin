# Ageing impairs economic choices in tufted capuchin monkeys

Analysis code for: Lanzarini F, Gastaldi S, Padoa-Schioppa C, Visalberghi E, Addessi E. *Ageing impairs economic choices in tufted capuchin monkeys*. 

Data: https://doi.org/10.5281/zenodo.23619148

## Summary

Cognitive ageing is associated with less consistent economic choices in humans, but cross-sectional studies cannot separate ageing from inter-individual differences. We tested the same tufted capuchin monkeys (*Sapajus* spp.) twice, after intervals of about 15 and 10 years, replicating two earlier studies on value-based choices with food and tokens. Monkeys chose between different quantities of three goods (A, B, C; high-, medium- and low-preferred) offered in pairs (A–B, B–C, A–C). For each pair, the code fits a cumulative normal to the choices as a function of the log offer ratio and extracts the relative value (`rho`) and the steepness of the choice curve (`eta = 1/w`, an index of choice consistency). Relative values are then combined to test transitivity (u + v = w).

In the paper, the proportion of inconsistent sessions increased with age, while no session violated transitivity, and `eta` decreased significantly between the two time points (paired Wilcoxon test, p = 0.038, median Δη = −0.79).

## Experiments

| Paper | Code | Experiment name in code | T1 → T2 | Monkeys |
|-------|------|-------------------------|---------|---------|
| Experiment 1: transitivity in food choices | `tra` | `Transitivity` | 2002 → 2017 (~15 years) | Cognac, Pepe, Roberta, RobinHood, Robiola, Robot, Virginia |
| Experiment 2, food condition | `ftr` | `FoodTransitivity` | 2007 → 2017 (~10 years) | Gal, Paprica, Robot, Sandokan |
| Experiment 2, token condition | `ttr` | `TokenTransitivity` | 2007 → 2017 (~10 years) | Gal, Paprica, Robot, Sandokan |

Ten monkeys in total; Robot took part in both experiments. All three experiments share the same analysis (`analyze_tra` and `analyze_ttr` call `analyze_ftr`). At T2, Experiment 1 had one experimental session of 72 trials per food triplet (split over two days), and Experiment 2 had five sessions of 68 trials per condition.

## Repository contents

All scripts are in the repository root.

| File | Purpose |
|------|---------|
| `README.md` | This file. |
| `LICENSE` | MIT License. |
| `anaexp.m` | **Main script.** For the chosen experiment, loops over all monkeys and sessions, runs the single-session analysis, collects the results, and saves summary files and per-session PDF figures. |
| `monkeylist_read.m` | Defines the list of monkeys (`monkeys`, full names; `mnks`, 3-letter codes). |
| `readset.m` | Script (not a function) that unpacks a session parameter structure `parset` into the workspace (`monkey`, `session`, goods, and the trial matrix `data`). Concatenates all `parset.dataset_<k>` listed in `parset.datasets`. |
| `analyze_ftr.m` | **Core single-session analysis.** For each pair (AB, BC, AC): builds the choice table, fits the cumulative normal, computes `x0`, `w`, `rho`, `eta`, `Rsq`, draws the figure and computes the transitivity p-value. |
| `analyze_tra.m`, `analyze_ttr.m` | Wrappers that call `analyze_ftr` for the `tra` and `ttr` experiments (the three experiments share the same analysis). |
| `makeanalysis_fch.m` | Builds, for one pair, the table of choices per offer (fraction of choices of the second good, latencies, second thoughts, number of trials) and fits a step function to estimate the indifference ratio range. |
| `plot_sigmoidfit_mod.m` | Draws one panel (one pair) of the 1×3 session figure: fitted curve, observed choice fractions, forced choices, and fitted parameters. |
| `filter_paired_sessions.m` | Keeps only the sessions that are present at both time points (`T == 1` and `T == 2`), for each monkey and experiment. |
| `longitudinal_eta.m` | **Longitudinal analysis.** Compares `eta` between T1 and T2 with a paired Wilcoxon signed-rank test. |
| `longitudinal_eta_figure.m` | **Figure 4.** Scatter plot of `eta` at T2 against `eta` at T1 for all paired comparisons (same data selection as `longitudinal_eta.m`). Saves `Fig4_eta_T1_vs_T2.pdf` and `Fig4_source_data.csv`. |
| `session_class_figure.m` | **Figures 2A, 3A and 3C.** Bar charts of the percentage of Inconsistent and Transitive sessions at T1 and T2, from `session_tot.xlsx`. Saves `Fig2A.pdf`, `Fig3A.pdf`, `Fig3C.pdf` and the corresponding `Fig*_source_data.csv`. |
| `analysis_Stata17.txt` | .txt file reporting analysis done with Stata17 and their relative code line and explanation |

### Data folder layout

The `Data` folder can be downloaded from the Zenodo repository: https://doi.org/10.5281/zenodo.23619148
The `Data` folder contains the session lists, the table used for the longitudinal analysis, and one subfolder per monkey with the session scripts:

```
Data/
├── sessionlist_cog.mat ... sessionlist_vir.mat   % one session list (table) per monkey, 10 files
├── sessionlist_cog.mat ... sessionlist_vir.csv   % same session list table in CSV format
├── session_tot.xlsx                              % input of longitudinal_eta.m
├── session_tot.csv                               % same table in CSV format
├── Cognac/
│   ├── cog<date><n>_tra.m                        % one session script per session
│   ├── cog<date><n>_tra.csv                      % same session in CSV format
│   └── ...
├── Gal/
├── Paprica/
├── Pepe/
├── Roberta/
├── RobinHood/
├── Robiola/
├── Robot/
├── Sandokan/
└── Virginia/
```

Monkeys (full name / code): Cognac (`cog`), Gal (`gal`), Paprica (`pap`), Pepe (`pep`), Roberta (`rob`), RobinHood (`rho`), Robiola (`rol`), Robot (`rot`), Sandokan (`san`), Virginia (`vir`).

## Requirements

- **MATLAB**: **R2018b or later** is required.
- **Stata 17**: used in the paper for the random-effects logistic regressions (line of code as .txt file).
- **Curve Fitting Toolbox** (`fit`, `fittype`)
- **Statistics and Machine Learning Toolbox** (`normcdf`, `ztest`, `signrank`, `range`)

## How to reproduce the analyses

1. **Get the code and the data.** Clone this repository and download the data from https://doi.org/10.5281/zenodo.23619148. Arrange the data as shown above.
2. **Set the paths.** In `anaexp.m`, replace the placeholder `'Data/'` in `dir_path = fullfile('Data/', monkey)` with the full path of your `Data` folder. Add the `Data` folder to the MATLAB path (the `sessionlist_<mnk>.mat` files are in its root), and start MATLAB in the repository folder (or add it to the path).
3. **Run the single-session analysis, once per experiment.** In `anaexp.m`, uncomment one `experiment` / `expr` pair at a time (`tra`, `ftr`, `ttr`) and run `anaexp`. Keep `makefigs = 1`: the transitivity p-values are computed only when figures are produced. Set `printplots = 0` to skip the PDF export. Outputs are described below; summary files are written to the current working directory.
4. **Longitudinal table.** The table used by the longitudinal analysis, `Data/session_tot.xlsx` (also provided as `session_tot.csv`), is **provided and was compiled manually** from the `summary_<expr>_all_sessions.csv` files produced in step 3 (see "Variables"). It can be used directly.
5. **Run the longitudinal analysis.** Make `Data/session_tot.xlsx` available in the working directory (or add `Data` to the path) and run `longitudinal_eta`. It prints the p-value of the paired Wilcoxon signed-rank test and the median and mean differences of `eta` (T2 − T1). With the provided `session_tot.xlsx` this gives N = 54 paired comparisons, p = 0.038, a median difference of −0.79 and a mean difference of −1.15 (the values reported in the paper).
6. **Make Figure 4.** Run `longitudinal_eta_figure`. It saves the figure (`Fig4_eta_T1_vs_T2.pdf`) and the plotted data (`Fig4_source_data.csv`).
7. **Make Figures 2A, 3A and 3C.** Run `session_class_figure`. It saves the three figures (`Fig2A.pdf`, `Fig3A.pdf`, `Fig3C.pdf`) and their source data (`Fig2A_source_data.csv`, `Fig3A_source_data.csv`, `Fig3C_source_data.csv`).

## Analysis details

### Single session (`analyze_ftr`)

For each pair of goods (X, Y) among AB, BC, AC:

1. Select the trials in which only the two goods of the pair are offered (the third good has quantity 0).
2. For each offer, compute the fraction of choices of the second good Y (`makeanalysis_fch`). Trials in which only one of the two goods is offered are *forced choices* (not implemented in T2); they are not used in the fit.
3. Fit a cumulative normal to the fraction of Y choices as a function of the log offer ratio:

   `P(choose Y) = normcdf( log(qY / qX), x0, w )`

   where `qX` and `qY` are the offered quantities.
4. Derive `rho = exp(x0)` (indifference point, i.e. the relative value of X in units of Y) and `eta = 1/w` (steepness).


### Transitivity test

Relative values are combined as `[x0_AB, x0_BC, -x0_AC]`. If choices are transitive, their sum is expected to be 0. The test is a z-test of that sum against 0, with standard deviation `sqrt(w_AB² + w_BC² + w_AC²)`. The p-value is reported in the figure title. If the order of the goods is not A>B>C (`x0_AB + x0_BC < 0`), the pairs are relabelled before the test.

Sessions in which any pair has `|x0| >= log(20)` are flagged as extreme (`ExtremeX0 = true`); for them the p-value is not computed (it is reported as `-1`).


### Session figure (`plot_sigmoidfit_mod`)

Three panels (AB, BC, AC), each showing the fitted cumulative normal (blue line), the observed choice fractions (black dots), the forced choices (placed outside the range of the tested offers, at 0 and 1), the offers on the x axis (`#Y : #X`), and the fitted values μ (`exp(x0)`), σ (`exp(w)`), ρ and η.

**Sessions shown in the paper.** Dates are in the format YYMMDD; "session of the day" is the number in the figure title (`parset.session`), and "index" is the value of `session` in `session_tot`.

| Panel | Subject | Experiment | T | Date | Index in `session_tot` | Class |
|-------|---------|------------|---|---------------------------|------------------------|-------|
| Fig. 2B | Virginia | `tra` | 2 | 170601 | 1 | Transitive |
| Fig. 3B (grey) | Paprica | `ftr` | 1 | 070301 | 1 | Transitive |
| Fig. 3B (blue) | Paprica | `ftr` | 2 | 170717 | 2 | Inconsistent |
| Fig. 3D (grey) | Gal | `ttr` | 1 | 070403 | 3 | Transitive |
| Fig. 3D (yellow) | Gal | `ttr` | 2 | 171010 | 5 | Inconsistent |


### Longitudinal analysis (`longitudinal_eta`)

1. Load `session_tot.xlsx`.
2. For each pair, exclude extreme comparisons (`rho > ratio_max`).
3. Keep only sessions present at both T1 and T2 (`filter_paired_sessions`).
4. Pool `eta` across pairs and experiments, aligning T1 and T2 by session.
5. Paired Wilcoxon signed-rank test on `eta` (T2 vs T1).

## Variables

### Session scripts: the `parset` structure

Each session script `<mnk><date><n>_<expr>.m` defines a structure `parset`:

| Field | Description |
|-------|-------------|
| `monkey` | Monkey name (text). |
| `experiment` | Experiment name (text). |
| `date` | Session date (text). Format: yymmdd |
| `session` | Session number within the day (number). |
| `goods` | Cell array with the names of the three goods, in the order A, B, C. |
| `goodweight_lims` | (not used in T2) Cell array with the food weight limits `[min max]`, in grams (`readset` stores their means in `weights`; not used by the analysis). |
| `datasets` | Vector of indices of the data matrices to concatenate. |
| `dataset_<k>` | Trial matrix (numeric, one row per trial), see below. |


### Trial matrix (`data`, columns of `dataset_<k>`)

At least 7 columns; only the first 7 are used.

| Column | Variable | Description |
|--------|----------|-------------|
| 1 | `trial_index` | Not used by the analysis. |
| 2 | `qA` | Offered quantity of good A, as number of items (food pieces or tokens); 0 if A is not offered. The sign means the left/right position of the offer. Its sign is used to recode the choice (column 5). |
| 3 | `qB` | Offered quantity of good B (number of items); 0 if B is not offered. |
| 4 | `qC` | Offered quantity of good C (number of items); 0 if C is not offered. |
| 5 | `choice` | Choice code (±1); multiplied by the sign of the first good's quantity |
| 6 | `latency` | (not used by the analysis). Choice latency; values > 0 are valid. Unit: seconds |
| 7 | `secondthought` | (not used by the analysis) Second-thought indicator |


### Session list: `sessionlist_<mnk>.mat`

A table with one row per session:

| Column | Description |
|--------|-------------|
| `sessionDate` | Session date (text), used in the session script name. |
| `sessionNum` | Session number within the day (number). |
| `expr_code` | Experiment code: `tra`, `ftr` or `ttr`. |


### Choice table per pair (`table01`, from `makeanalysis_fch`)

| Column | Description |
|--------|-------------|
| 1 | Offered quantity of the first good of the pair. |
| 2 | Offered quantity of the second good of the pair. |
| 3 | Fraction of choices of the second good (0–1). |
| 4 | Mean choice latency (same unit as the input latency). (not used in T2) |
| 5 | Standard deviation of the latency. |
| 6 | Number of second thoughts. (not used in T2)|
| 7 | Number of trials with this offer. |


### Output of `anaexp`

`summary_<expr>_all_sessions.csv` / `.mat` (`allSessionsTable`): one row per session.

| Column | Unit | Description |
|--------|------|-------------|
| `AB_x0`, `BC_x0`, `AC_x0` | log(quantity ratio), dimensionless | Mean of the fitted cumulative normal (log indifference point) for each pair. |
| `AB_w`, `BC_w`, `AC_w` | log(quantity ratio), dimensionless | Standard deviation of the fitted cumulative normal. |
| `AB_rho`, `BC_rho`, `AC_rho` | quantity ratio, dimensionless | Indifference point, `exp(x0)`: ratio qY/qX at which the two goods are chosen equally often. |
| `AB_eta`, `BC_eta`, `AC_eta` | dimensionless | Steepness of the choice curve, `1/w` (lower values = noisier choices). |
| `AB_Rsq`, `BC_Rsq`, `AC_Rsq` | dimensionless | Adjusted R² of the cumulative-normal fit. It is `-Inf` when the fit has no residual degrees of freedom (e.g. as many non-forced offers as fitted parameters). |
| `Monkey` | – | Monkey name. |
| `Session` | – | Session identifier (date followed by session number). |
| `ExtremeX0` | logical | `true` if any pair has `abs(x0) >= log(20)`. |

The pairs in this table are reported as fitted (AB, BC, AC); the A>B>C relabelling is applied only to `relative_values`.

`summary_<expr>.mat` (`relative_values`): after the A>B>C relabelling, `mean` (sessions × 3) contains `[x0_AB, x0_BC, -x0_AC]`, `stdv` (sessions × 3) the corresponding `w` values, and `monk` the monkey code of each session.

`figures_<expr>_<monkey>_session_<file>.pdf`: one figure per session, saved in the monkey's folder.

### `session_tot.xlsx` / `session_tot.csv` (input of `longitudinal_eta`)

Table of the fitted parameters of every session (118 rows: 61 sessions at T1 and 57 at T2; 22 columns), compiled manually from the `summary_<expr>_all_sessions.csv` files produced by `anaexp`. The same table is provided in Excel and CSV format.

**Pair labels.** A, B and C are the three goods of a triplet (foods or tokens), ranked from the most preferred (A) to the least preferred (C). `AB`, `BC` and `AC` are the three binary comparisons. For a comparison between goods X and Y (e.g. `BC`: X = B, Y = C), `qX` and `qY` are the numbers of items offered.

**Model.** For each comparison, the proportion of choices of Y was fitted, on the non-forced offers (both goods offered), with a cumulative normal function of the log quantity ratio, by nonlinear least squares (`fit` with `fittype('normcdf(x,x0,w)')`, MATLAB Curve Fitting Toolbox):

`P(choose Y) = normcdf( log(qY/qX), x0, w )`

`x0` is the log quantity ratio at which X and Y are chosen equally often, and `w` is the standard deviation of the cumulative normal. From these: `rho = exp(x0)` (indifference point, relative value) and `eta = 1/w` (slope). `Rsq` is the adjusted R² of the fit.

**Time points and subjects.** `T = 1`: the previously published studies (Experiment 1: Padoa-Schioppa et al., data collected in 2002; Experiment 2: Addessi et al., data collected in 2007). `T = 2`: the present study (2017). Experiment 1 (`tra`): Cognac, Pepe, Roberta, RobinHood, Robiola, Robot, Virginia. Experiment 2 (`ftr` = food condition, `ttr` = token condition): Gal, Paprica, Robot, Sandokan.

| Column | Unit | Description |
|--------|------|-------------|
| `monkey`, `mkn` | – | Monkey name and 3-letter code. |
| `T` | – | Time point: `1` = previously published study (2002 or 2007), `2` = present study (2017). |
| `session` | – | Session number (1–5), used to match a session at T1 with the corresponding session at T2 for the same monkey and experiment (it is not the date); shared across monkeys. |
| `expr` | – | Experiment/condition: `tra` = Experiment 1 (food), `ftr` = Experiment 2 food condition, `ttr` = Experiment 2 token condition. |
| `AB_x0`, `BC_x0`, `AC_x0` | log(quantity ratio), dimensionless | Mean of the fitted cumulative normal (log indifference point) for each comparison. |
| `AB_rho`, `BC_rho`, `AC_rho` | quantity ratio, dimensionless | Indifference point, `exp(x0)`, in units of Y per unit of X. |
| `AB_eta`, `BC_eta`, `AC_eta` | dimensionless | Slope of the choice function, `1/w` (lower values = noisier choices). |
| `AB_Rsq`, `BC_Rsq`, `AC_Rsq` | dimensionless | Adjusted R² of the fit; `-Inf` when the fit has no residual degrees of freedom (shown as `#NAME?` in Excel). |
| `ExtremeX0` | 0/1 | `1` if `abs(x0) >= log(20)` for at least one of the three comparisons, `0` otherwise. |
| `AB_ratio_max`, `BC_ratio_max`, `AC_ratio_max` | quantity ratio, dimensionless | Maximum quantity ratio qY/qX offered for the comparison. Comparisons with `rho > ratio_max` are excluded from the longitudinal analysis. |
| `session_class` | – | `Inconsistent` or `Transitive`. `Inconsistent`: at least one comparison is not fitted by a monotonic normal sigmoid, identified by `ExtremeX0 = 1` (61 sessions). `Transitive`: `ExtremeX0 = 0` and the identity `x0_AB + x0_BC = x0_AC` is not rejected by the z-test (57 sessions). No session was non-transitive. |

Identical fitted values in different sessions are expected when the choice patterns are identical: the fit depends only on the choice proportions and on the offered quantity ratios, which are the same across sessions and monkeys. This happens for deterministic, step-like patterns (`Rsq = 1`) and for degenerate fits with extreme `x0` (undefined `Rsq`).


## Notes and known issues

- In `longitudinal_eta.m`, T1 and T2 values are aligned by sorting on `session` only. Since session numbers repeat across monkeys, this is correct only if the rows have the same monkey order at T1 and T2. With the provided `session_tot.xlsx` the result is identical to the one obtained by sorting on `{'mkn','session'}`; the latter would make the alignment independent of the row order.
- `Rsq` equals `-Inf` when the fit has no residual degrees of freedom, and Excel shows `-Inf` as `#NAME?`. In `session_tot.csv` this appears in 55 `Rsq` cells; in `session_tot.xlsx` they are read as missing values. `Rsq` is not used by the analysis. The same CSV also shows one `AB_rho` value rounded to `4.27E+240` (a failed fit, excluded by the `ratio_max` filter).
- `analyze_ftr` declares a fourth input argument `session`, which is not passed by the wrappers; the value is overwritten by `readset.m`.
- `plot_sigmoidfit_mod` receives `pair_names` but ignores it and uses its own fixed order `{'AB','BC','AC'}`.
- `makeanalysis_fch` also returns `nstar` and `Rsq` (error of the step-function fit); they are not used by the rest of the analysis.
- The random-effects logistic regressions comparing T1 and T2 (Stata 17) are reported as a .txt file in the repository.

## License

This project is licensed under the MIT License; see the [LICENSE](LICENSE) file for details.

## Citation

If you use this code, please cite:

> Lanzarini F, Gastaldi S, Padoa-Schioppa C, Visalberghi E, Addessi E. Ageing impairs economic choices in tufted capuchin monkeys. 
Data: https://doi.org/10.5281/zenodo.23619148


## Contact
Contact authors: francesca.lanzarini@esi-frankfurt.de, elsa.addessi@cnr.it