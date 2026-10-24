# Ageing impairs economic choices in tufted capuchin monkeys

Analysis code for: Lanzarini F, Gastaldi S, Padoa-Schioppa C, Visalberghi E, Addessi E. *Ageing impairs economic choices in tufted capuchin monkeys*. _TODO: add journal, year and DOI when available._

Data: https://doi.org/10.5281/zenodo.23266144

## Summary

Cognitive ageing is associated with less consistent economic choices in humans, but cross-sectional studies cannot separate ageing from inter-individual differences. We tested the same tufted capuchin monkeys (*Sapajus* spp.) twice, after intervals of about 15 and 10 years, replicating two earlier studies on value-based choices with food and tokens. Monkeys chose between different quantities of three goods (A, B, C; high-, medium- and low-preferred) offered in pairs (A–B, B–C, A–C). For each pair, the code fits a cumulative normal to the choices as a function of the log offer ratio and extracts the relative value (`rho`) and the steepness of the choice curve (`eta = 1/w`, an index of choice consistency). Relative values are then combined to test transitivity (u + v = w).

In the paper, the proportion of inconsistent sessions increased with age, while no session violated transitivity, and `eta` decreased significantly between the two time points (paired Wilcoxon test, p = 0.038, median Δη = −0.79).

## Experiments

| Paper | Code | Experiment name in code | T1 → T2 | Monkeys |
|-------|------|-------------------------|---------|---------|
| Experiment 1: transitivity in food choices | `tra` | `Transitivity` | 2002 → 2017 (~15 years) | Cognac, Pepe, Roberta, RobinHood, Robiola, Robot, Virginia |
| Experiment 2, transitivity in food condition | `ftr` | `FoodTransitivity` | 2007 → 2017 (~10 years) | Gal, Paprica, Robot, Sandokan |
| Experiment 2, transitivity token condition | `ttr` | `TokenTransitivity` | 2007 → 2017 (~10 years) | Gal, Paprica, Robot, Sandokan |

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
| `sessionlistread.m` | Legacy helper that reads a plain-text session list (`sessionlist_<monkey>.m`). Not used by `anaexp.m`, which uses the `.mat` session lists. |

### Data folder layout

The `Data` folder contains the session lists, the table used for the longitudinal analysis, and one subfolder per monkey with the session scripts:

```
Data/
├── sessionlist_cog.mat ... sessionlist_vir.mat   % one session list (table) per monkey, 10 files
├── session_tot.xlsx                              % input of longitudinal_eta.m
├── session_tot.csv                               % same table in CSV format
├── Cognac/
│   ├── cog<date><n>_tra.m                        % one session script per session
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
- **Curve Fitting Toolbox** (`fit`, `fittype`)
- **Statistics and Machine Learning Toolbox** (`normcdf`, `ztest`, `signrank`, `range`)

## How to reproduce the analyses

1. **Get the code and the data.** Clone this repository and download the data from https://doi.org/10.5281/zenodo.23266144. Arrange the data as shown above.
2. **Set the paths.** In `anaexp.m`, replace the placeholder `'...\'` in `dir_path = fullfile('...\', monkey)` with the full path of your `Data` folder. Add the `Data` folder to the MATLAB path (the `sessionlist_<mnk>.mat` files are in its root), and start MATLAB in the repository folder (or add it to the path).
3. **Run the single-session analysis, once per experiment.** In `anaexp.m`, uncomment one `experiment` / `expr` pair at a time (`tra`, `ftr`, `ttr`) and run `anaexp`. Keep `makefigs = 1`: the transitivity p-values are computed only when figures are produced. Set `printplots = 0` to skip the PDF export. Outputs are described below; summary files are written to the current working directory.
4. **Longitudinal table.** The table used by the longitudinal analysis, `Data/session_tot.xlsx` (also provided as `session_tot.csv`), is **provided and was compiled manually** from the `summary_<expr>_all_sessions.csv` files produced in step 3 (see "Variables"). It can be used directly.
5. **Run the longitudinal analysis.** Make `Data/session_tot.xlsx` available in the working directory (or add `Data` to the path) and run `longitudinal_eta`. It prints the p-value of the paired Wilcoxon signed-rank test and the median and mean differences of `eta` (T2 − T1). With the provided `session_tot.xlsx` this gives N = 54 paired comparisons, p = 0.038, a median difference of −0.79 and a mean difference of −1.15 (the values reported in the paper).

## Analysis details

### Single session (`analyze_ftr`)

For each pair of goods (X, Y) among AB, BC, AC:

1. Select the trials in which only the two goods of the pair are offered (the third good has quantity 0).
2. For each offer, compute the fraction of choices of the second good Y (`makeanalysis_fch`). Trials in which only one of the two goods is offered are *forced choices*; they are not used in the fit (offered only in T1).
3. Fit a cumulative normal to the fraction of Y choices as a function of the log offer ratio:

   `P(choose Y) = normcdf( log(qY / qX), x0, w )`

   where `qX` and `qY` are the offered quantities.
4. Derive `rho = exp(x0)` (indifference point, i.e. the relative value of X in units of Y) and `eta = 1/w` (steepness).

### Transitivity test

Relative values are combined as `[x0_AB, x0_BC, -x0_AC]`. If choices are transitive, their sum is expected to be 0. The test is a z-test of that sum against 0, with standard deviation `sqrt(w_AB² + w_BC² + w_AC²)`. The p-value is reported in the figure title. If the order of the goods is not A>B>C (`x0_AB + x0_BC < 0`), the pairs are relabelled before the test.

Sessions in which any pair has `|x0| >= log(20)` are flagged as extreme (`ExtremeX0 = true`); for them the p-value is not computed (it is reported as `-1`).

### Session figure (`plot_sigmoidfit_mod`)

Three panels (AB, BC, AC), each showing the fitted cumulative normal (blue line), the observed choice fractions (black dots), the forced choices (placed outside the range of the tested offers, at 0 and 1), the offers on the x axis (`#Y : #X`), and the fitted values μ (`exp(x0)`), σ (`exp(w)`), ρ and η.

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
| `goodweight_lims` | Cell array with the weight limits `[min max]`, in grams, of one piece of the first two goods (`readset` stores their means in `weights`; not used by the analysis). |
| `datasets` | Vector of indices of the data matrices to concatenate. |
| `dataset_<k>` | Trial matrix (numeric, one row per trial), see below. |

### Trial matrix (`data`, columns of `dataset_<k>`)

At least 7 columns; only the first 7 are used.

| Column | Variable | Description |
|--------|----------|-------------|
| 1 | _(not used)_ | Not used by the analysis. Trial index |
| 2 | `qA` | Offered quantity of good A, as number of items (food pieces or tokens); 0 if A is not offered. Its sign is used to recode the choice (column 5). The sign refer to left/right position |
| 3 | `qB` | Offered quantity of good B (number of items); 0 if B is not offered. |
| 4 | `qC` | Offered quantity of good C (number of items); 0 if C is not offered. |
| 5 | `choice` | Choice code (±1); multiplied by the sign of the first good's quantity, it gives +1 for the first good of the pair and −1 for the second. |
| 6 | `latency` | Choice latency; values > 0 are valid. Unit: seconds. Not always reported |
| 7 | `secondthought` | Second-thought indicator; trials with values > 0 are counted. (used only in T1) |

The pair of interest is selected from the trials in which the third good has quantity 0 (column 4 = 0 for AB, column 2 = 0 for BC, column 3 = 0 for AC).

### Session list: `sessionlist_<mnk>.mat`

A table with one row per session:

| Column | Description |
|--------|-------------|
| `sessionDate` | Session date (text), used in the session script name. (yymmdd) |
| `sessionNum` | Session number within the day (number). |
| `expr_code` | Experiment code: `tra`, `ftr` or `ttr`. |

### Choice table per pair (`table01`, from `makeanalysis_fch`)

| Column | Description |
|--------|-------------|
| 1 | Offered quantity of the first good of the pair. |
| 2 | Offered quantity of the second good of the pair. |
| 3 | Fraction of choices of the second good (0–1). |
| 4 | Mean choice latency (same unit as the input latency). (only for T1) |
| 5 | Standard deviation of the latency. (only for T1) |
| 6 | Number of second thoughts. (only for T1) |
| 7 | Number of trials with this offer. |

### Output of `anaexp`

`summary_<expr>_all_sessions.csv` / `.mat` (`allSessionsTable`): one row per session.

| Column | Unit | Description |
|--------|------|-------------|
| `AB_x0`, `BC_x0`, `AC_x0` | log(quantity ratio), dimensionless | Mean of the fitted cumulative normal (log indifference point) for each pair. |
| `AB_w`, `BC_w`, `AC_w` | log(quantity ratio), dimensionless | Standard deviation of the fitted cumulative normal. |
| `AB_rho`, `BC_rho`, `AC_rho` | quantity ratio, dimensionless | Indifference point, `exp(x0)`: ratio qY/qX at which the two goods are chosen equally often. |
| `AB_eta`, `BC_eta`, `AC_eta` | dimensionless | Steepness of the choice curve, `1/w` (lower values = noisier choices). |
| `AB_Rsq`, `BC_Rsq`, `AC_Rsq` | dimensionless | Adjusted R² of the cumulative-normal fit. |
| `Monkey` | – | Monkey name. |
| `Session` | – | Session identifier (date followed by session number). |
| `ExtremeX0` | logical | `true` if any pair has `abs(x0) >= log(20)`. |

The pairs in this table are reported as fitted (AB, BC, AC); the A>B>C relabelling is applied only to `relative_values`.

`summary_<expr>.mat` (`relative_values`): after the A>B>C relabelling, `mean` (sessions × 3) contains `[x0_AB, x0_BC, -x0_AC]`, `stdv` (sessions × 3) the corresponding `w` values, and `monk` the monkey code of each session.

`figures_<expr>_<monkey>_session_<file>.pdf`: one figure per session, saved in the monkey's folder.

### Input of `longitudinal_eta`: `session_tot.xlsx`

Compiled manually from the `summary_<expr>_all_sessions.csv` files (118 rows: one per session and time point, 61 at T1 and 57 at T2).

| Column | Description |
|--------|-------------|
| `monkey`, `mkn` | Monkey name and 3-letter code. |
| `T` | Time point: `1` or `2`. |
| `session` | Session number, used to match a session at T1 with the corresponding session at T2 for the same monkey and experiment (same value at T1 and T2; it is not the date). It takes values 1–5 and is shared across monkeys. |
| `expr` | Experiment code (`tra`, `ftr`, `ttr`). |
| `AB_x0`, `BC_x0`, `AC_x0` | Log indifference point of each pair (as in the `anaexp` output). |
| `AB_rho`, `BC_rho`, `AC_rho` | Indifference point, `exp(x0)`. |
| `AB_eta`, `BC_eta`, `AC_eta` | Steepness `1/w`. |
| `AB_Rsq`, `BC_Rsq`, `AC_Rsq` | Adjusted R² of the fit; empty when it could not be computed. |
| `ExtremeX0` | 1 if any pair has `abs(x0) >= log(20)`, 0 otherwise. |
| `AB_ratio_max`, `BC_ratio_max`, `AC_ratio_max` | Maximum offer ratio qY/qX tested for the pair (integer); comparisons with `rho > ratio_max` are excluded from the longitudinal analysis. |
| `session_class` | `Inconsistent` or `Transitive`. In this dataset, `Inconsistent` corresponds exactly to `ExtremeX0 = 1` (61 sessions), and all other sessions (57) are `Transitive`. |

## Not included in this code

- The classification of sessions as *Inconsistent* or *Transitive* is not computed inside `analyze_ftr`: it is stored in the `session_class` column of `session_tot.xlsx`, where *Inconsistent* corresponds to the `ExtremeX0` flag computed by `anaexp`. The z-test p-value of each session is shown only in the figure titles. 

## Notes and known issues

- In `longitudinal_eta.m`, T1 and T2 values are aligned by sorting on `session` only. Since session numbers repeat across monkeys, this is correct only if the rows have the same monkey order at T1 and T2. With the provided `session_tot.xlsx` the result is identical to the one obtained by sorting on `{'mkn','session'}`; the latter would make the alignment independent of the row order.
- `session_tot.csv` contains the Excel error `#NAME?` in 55 `Rsq` cells (they are empty in `session_tot.xlsx`), and shows one `AB_rho` value rounded to `4.27E+240` (a failed fit, excluded by the `ratio_max` filter). `Rsq` is not used by the analysis.
- `plot_sigmoidfit_mod` receives `pair_names` but ignores it and uses its own fixed order `{'AB','BC','AC'}`.

## License

This project is licensed under the MIT License; see the [LICENSE](LICENSE) file for details.

## Citation

If you use this code, please cite:

> Lanzarini F, Gastaldi S, Padoa-Schioppa C, Visalberghi E, Addessi E. Ageing impairs economic choices in tufted capuchin monkeys. 

Data: https://doi.org/10.5281/zenodo.23266144
