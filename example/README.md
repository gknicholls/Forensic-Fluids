# Introduction

We present a couple of examples of how to run the Java codes that implement the classification of forensic body fluids via BDP.
These examples are selected from the analysis presented in the paper by Wu, C. H., Roeder, A. D., & Nicholls, G. K. (2023) and cover both Bayesian and Cut-Model analyses.
Section 1 explains how to execute the body fluid classification via BDP in Bayesian inference, while Section 2 shows how to perform the classification in Cut-Model inference instead.
Section 3 demonstrates how some summaries of interest are extracted by post-processing.


Java (version 14.0.1 or above) is required for Sections 1 & 2, while Section 3 uses the R markdown file constructed by R version 4.1.2.

# Section 1: Classification of Forensic Body Fluids by Bayesian Inference

In this example, the 46 mRNA profiles in a test dataset (saved in the comma-delimited file, testSamplesBin_2022_09_22_unknown.csv) are classified by jointly using the BDP in Bayesian inference. These test profiles are treated as if their labels were unknown.

The BDP is trained using labelled 321 labelled mRNA profiles (saved in the following five comma delimited files): 

* 59 cervical fluid profiles (singleBin_cvf.csv)
* 31 menstrual blood profiles (singleBin_mtb.csv)
* 80 saliva profiles (singleBin_slv.csv)
* 65 blood profiles (singleBin_bld.csv)
* 86 semen profiles (singleBin_smn.csv)
In the Bayesian analysis, the training of BDP and the classification of test mRNA profiles are carried out jointly in a single analysis. Here, we assume that the number of subtypes within each body fluid type does not exceed five.


To run the analysis at the command line, use the following command:

java -cp ClassifyForensicFluid.jar classify.ClassifyForensicFluid trainSamples_2022_09_22_bayes_bdp_J5.txt


* The ClassifyForensicFluid.jar bundle contains all the compiled Java codes for implementing classification by BDP.
* classify.ClassifyForensicFluid is the main class to be called in the ClassifyForensicFluid.jar bundle to start the software program for the Bayesian analysis.
* The "trainSamples_2022_09_22_bayes_bdp_J5.txt" file is a text file with two columns that specify all information and data required for the analysis. Apart from the mRNA profiles data files, i.e., the comma-delimited files mentioned above, this input file also specifies pre-computed inputs for speeding up the calculation, namely, all the partition configurations for a given marker group, which are stored in the text files "allPartitionSets5.txt" and "allPartitionSets7.txt."

Shortly after running the above command, a text file, "testSamplesBin_2022_09_22_bayes_bdp_J5_all.log" will be produced, and the posterior samples simulated by MCMC will be stored in this file. 
For this example, thinning is applied to save space, and only every 10000th sample is recorded.

Once the analysis is completed, we can use the output file, "testSamplesBin_2022_09_22_bayes_bdp_J5_all.log", to summarise the classification results (see Section 3 below).


---

# Section 2: Classification of Forensic Body Fluids by Cut-Model Inference

This example again uses the 46 test profiles in Section 1, but here, they are classified jointly using the BDP in Cut-Model inference instead. 
Therefore, the analysis consists of two stages.
Sections 2.1 and 2.2 respectively explain how to execute the Java codes implementing BDP for Stages 1 and 2 of the Cut-Model analysis.


## Section 2.1: Stage 1 of Cut-Model Inference:

In Stage 1, we train the BDP using the training data only. The training data containing 321 mRNA profiles is the same as in Section 1. We assume that the number of subtypes within each body fluid type does not exceed five.

To perform Stage 1 of the Cut-Model analysis at the command line, use the following command:

java -cp ClassifyForensicFluid.jar classify.ClassifyForensicFluid trainSamples_2022_09_22_bayes_bdp_J5.txt

* ClassifyForensicFluid.jar and classify.ClassifyForensicFluid is the same as in Section 1.
* The "trainSamples_2022_09_22_bayes_bdp_J5.txt" file is a text file with two columns that specify all the information and data required for Stage 1 of the analysis.
The key difference between this text file and "trainSamples_2022_09_22_bayes_bdp_J5.txt" in Section 1 is that "trainSamples_2022_09_22_bayes_bdp_J5.txt" must *only* specify the training profile data files and so provides no information on the unlabelled profiles to be classified.

This analysis produces an output file called "trainSamples_2022_09_22_bayes_bdp_J5.log," which contains posterior samples of the subtype clustering for each fluid type given the training data. 
This serves as the _main chain_ of Stage 2 of the Cut-Model analysis.

## Section 2.2: Stage 2 of Cut-Model Inference:

In Stage 2, we fix the subtype clustering of the training profiles to the simulated posterior distribution obtained in Stage 1. Then, for each sample drawn from this posterior distribution, we infer the fluid type of the 46 test profiles jointly using Gibbs sampling.

To perform Stage 2 of the Cut-Model analysis at the command line, run the following command:

java -cp ClassifyForensicFluid.jar classify.ClassifyForensicFluidCutModel testSamplesBin_2022_09_22_cut_bdp_J5_all.txt

* ClassifyForensicFluid.jar is the same as Section 1.
* classify.ClassifyForensicFluidCutModel is the main class to be called in the ClassifyForensicFluid.jar bundle to start the software program for Stage 2 of the analysis.
* The "testSamplesBin_2022_09_22_cut_bdp_J5_all.txt" file is a text file with two columns that specify all the information and data required to execute the analysis. 
Therefore, it includes comma-delimited files for the test and training mRNA profile data, as well as pre-computed input files ("allPartitionSets5.txt" and "allPartitionSets7.txt").

In Stage 2, the output file, "testSamplesBin_2022_09_22_cut_bdp_J5_all.log," is produced. This contains the Cut-Model posterior samples of the classification of the test mRNA profiles, allowing us to summaries of classification results (see Section 3 below).

---

# Section 3: Post-MCMC analysis

In the output files from the MCMC simulations, the fluid type classification is embedded in the posterior distribution of the subtype clustering configuration of the training and test profiles.
Therefore, some post-processing in R is required to extract some information of interest.

The R markdown file postMCMCSummaries.Rmd provides a couple of examples of the summaries used in the paper, namely, 

1. the posterior distribution of the fluid type of an unlabelled profile, and 
2. the posterior distribution of the number of subtypes given a fluid type, specifically, Figure 10 a) & b).

To run postMCMCSummaries.Rmd, please ensure that the output files testSamplesBin_2022_09_22_bayes_bdp_J5_all.log and testSamplesBin_2022_09_22_cut_bdp_J5_all.log are in the R working directory.
