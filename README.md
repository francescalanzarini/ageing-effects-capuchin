# ageing-effects-capuchin
# Capuchin Transitivity Analysis

MATLAB code for analyzing economic-choice data from capuchin monkeys in three transitivity experiments. For each session, the pipeline fits psychometric (cumulative-normal) curves to the choices in the three pairwise comparisons **A–B**, **B–C** and **A–C**, extracts the relative values and choice-noise parameters, and tests whether the monkey's choices violate transitivity.

This repository contains the code used for Lanzarini et al., *"Ageing impairs economic choices in tufted capuchin monkeys"*.

The data used in the paper are available on Zenodo: https://doi.org/10.5281/zenodo.23266144

## Experiments

| Code  | Experiment         | Analysis function |
|-------|--------------------|-------------------|
| `tra` | `Transitivity`     | `analyze_tra`     |
| `ftr` | `FoodTransitivity` | `analyze_ftr`     |
| `ttr` | `TokenTransitivity`| `analyze_ttr`     |

`analyze_tra` and `analyze_ttr` are thin wrappers around `analyze_ftr`; all three experiments share the same analysis.

## Monkeys

Ten subjects, listed in `monkeylist_read.m` (full name / short code):
Cognac (`cog`), Gal (`gal`), Paprica (`pap`), Pepe (`pep`), Roberta (`rob`), RobinHood (`rho`), Robiola (`rol`), Robot (`rot`), Sandokan (`san`), Virginia (`vir`).

## Repository structure

| File | Role |
|------|------|
| `anaexp.m` | **Main script.** Loops over monkeys and sessions of the chosen experiment, runs the analysis, collects results, saves summaries and per-session PDF figures. |
| `monkeylist_read.m` | Defines the monkey list (`monkeys`, `mnks`). |
| `sessionlistread.m` | Reads a plain-text `sessionlist_<monkey>.m` file and returns the sessions (date, number) matching a given experiment. Legacy alternative to the `.mat` session tables used in `anaexp.m`. |
| `readset.m` | Script that unpacks a session parameter structure (`parset`) into the variables used by the analysis (`monkey`, `session`, goods, `data`, ...). Concatenates all datasets listed in `parset.datasets`. |
| `analyze_ftr.m` | Core single-session analysis (see below). |
| `analyze_tra.m`, `analyze_ttr.m` | Wrappers calling `analyze_ftr` for the `tra` and `ttr` experiments. |
| `plot_sigmoidfit_mod.m` | Plotting function called by `analyze_ftr` (when `makefig = 1`), once per pair. Draws one panel of a 1×3 figure (AB, BC, AC) showing the fitted cumulative normal, the observed choice fractions and the forced choices (see "Figures" below). |
| `makeanalysis_fch.m` | Builds the per-offer choice table (percentage choosing B, latencies, second thoughts, number of trials) and fits a step function to estimate the indifference ratio range. |
| `filter_paired_sessions.m` | Keeps only sessions recorded at both time points (`T == 1` and `T == 2`) for each monkey and experiment. |
| `longitudinal_eta.m` | Longitudinal analysis: compares the choice-noise parameter `eta` between T1 and T2. |

## Analysis pipeline

### 1. Single-session analysis (`analyze_ftr`)

For each of the three pairs (AB, BC, AC):

1. Select the trials of that pair and tabulate, for each offer (quantity ratio), the fraction of choices of each option (`makeanalysis_fch`).
2. Separate non-forced choices from forced choices (forced-A / forced-B trials) and keep non-forced offers for the fit.
3. Fit a cumulative normal to the fraction of B choices as a function of the **log** offer ratio:

   `P(choose B) = normcdf(log(qB/qA), x0, w)`

Parameters stored for each pair (`psyphycell`, one row per pair):

| Parameter | Meaning |
|-----------|---------|
| `x0`  | Mean of the cumulative normal (log indifference point) |
| `w`   | Standard deviation of the cumulative normal (choice noise, log space) |
| `rho` | Indifference point, `exp(x0)` (relative value) |
| `eta` | Steepness of the choice curve, `1/w` |
| `Rsq` | Adjusted R² of the fit |

The function also returns `session_table`, a one-row table with all parameters for the three pairs, using column names `AB_x0, AB_w, AB_rho, AB_eta, AB_Rsq, BC_x0, ..., AC_Rsq`.

### 2. Transitivity test

Relative values are computed as `[x0_AB, x0_BC, -x0_AC]`. If transitivity holds, their sum is expected to be zero. The test is a z-test of that sum against 0, with standard deviation `sqrt(w_AB² + w_BC² + w_AC²)`; the resulting p-value is shown in the figure title. Before the test, the A>B>C ordering is fixed if needed (the pairs are relabelled when `x0_AB + x0_BC < 0`).

Sessions in which any pair has `|x0| >= log(20)` are flagged as **extreme** (`ExtremeX0 = true`) and are excluded from the p-value computation (reported as `-1` in the figure title).

### Figures (`plot_sigmoidfit_mod`)

Each session produces one figure with three panels, always in the order AB, BC, AC (the order is hard-coded in the function). Each panel shows:

- the fitted cumulative normal (blue line);
- the observed fraction of choices of the second good, for each non-forced offer (black dots);
- the forced-choice offers, placed outside the range of the non-forced offers at steps of `log(2)`, at 0% (forced-A) and 100% (forced-B);
- x tick labels with the offers (`#second good : #first good`), y axis from 0 to 1;
- the fitted values, shown as μ (relative value, `exp(x0)`), σ (width, `exp(w)`), ρ and η.

If a pair has no data, the panel is left empty with the title "(no data)". The figure is resized after the third panel is drawn. The overall figure title, with the transitivity p-value, is added by `analyze_ftr`.

### 3. Batch analysis (`anaexp`)

For the selected experiment, `anaexp` runs every session of every monkey, and appends `Monkey`, `Session` and `ExtremeX0` to each session table.

### 4. Longitudinal analysis (`longitudinal_eta`)

1. Load `session_tot.xlsx` (manually compiled, see "Expected inputs").
2. For each pair, remove extreme comparisons (`rho > ratio_max`).
3. Keep only paired sessions (`filter_paired_sessions`).
4. Pool `eta` across experiments and pairs, aligning T1 and T2 by session.
5. Run a paired Wilcoxon signed-rank test on `eta` (T2 vs T1) and print the p-value, median and mean difference.

## Requirements

- MATLAB
- Curve Fitting Toolbox (`fit`, `fittype`)
- Statistics and Machine Learning Toolbox (`normcdf`, `ztest`, `signrank`)

## Usage

1. Set the placeholder paths (`'...\'`) in `anaexp.m` and `sessionlistread.m` to your local data directories.
2. Open `anaexp.m` and choose the experiment by uncommenting the corresponding `experiment` / `expr` pair. Optional flags:
   - `makestats` – save summary outputs
   - `makefigs` – produce one figure per session
   - `printplots` – export figures as PDF
3. Run `anaexp`.

## Expected inputs

The input data are not included in this repository; they are available on Zenodo (https://doi.org/10.5281/zenodo.23266144). The analysis expects:

- **Session scripts**, one per session, named `<mnk><date><sessionNum>_<expr>.m` (e.g. `cog<date><n>_tra.m`) and stored in one folder per monkey. Each defines a `parset` structure with at least: `monkey`, `experiment`, `date`, `session`, `goods` (3 items), `goodweight_lims`, `datasets`, and the data matrices `dataset_<k>`.
- **Session lists**, one per monkey: `sessionlist_<mnk>.mat`, a table with columns `sessionDate`, `sessionNum`, `expr_code`.
- `session_tot.xlsx` for the longitudinal analysis. This file is **compiled manually** (it is not generated by any script in this repository) from the per-session results of `anaexp` (`summary_<expr>_all_sessions.csv`), with additional information added by hand. Required columns:
  - `mkn`: monkey code (corresponds to `Monkey` in the `anaexp` output);
  - `expr`: experiment code (`tra`, `ftr`, `ttr`);
  - `session`: session identifier (corresponds to `Session` in the `anaexp` output);
  - `T`: time point of the session (`1` or `2`);
  - for each pair (`AB`, `BC`, `AC`): `<pair>_rho` and `<pair>_eta` (from the fit) and `<pair>_ratio_max` (the maximum offer ratio tested for that pair, used to exclude extreme comparisons where `rho > ratio_max`).

## Outputs

| File | Content |
|------|---------|
| `summary_<expr>.mat` | `relative_values` (mean and SD of the relative values, with monkey labels, one row per session) |
| `summary_<expr>_all_sessions.csv` / `.mat` | Table of all fitted parameters for all sessions |
| `figures_<expr>_<monkey>_session_<file>.pdf` | Per-session figure with the three psychometric fits and the transitivity p-value |

## License

This project is licensed under the MIT License; see the [LICENSE](LICENSE) file for details.

## Citation

If you use this code, please cite:

> Lanzarini et al., "Ageing impairs economic choices in tufted capuchin monkeys".

Data: https://doi.org/10.5281/zenodo.23266144
