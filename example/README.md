# Section 1: Classification of Forensic Body Fluids by Bayesian Inference

In this example, 46 test mRNA profiles (saved in the comma-delimited file, testSamplesBin_2022_09_22_unknown.csv) are classified by jointly using the BDP in Bayesian inference.

The BDP is trained using labeled 321 labelled mRNA profiles (saved in the following five comma delimited files): 

* 59 cervical fluid profiles (singleBin_cvf.csv)
* 31 menstrual blood profiles (singleBin_mtb.csv)
* 80 saliva profiles (singleBin_slv.csv)
* 65 blood profiles (singleBin_bld.csv)
* 86 semen profiles (singleBin_smn.csv)

In the Bayesian inference set up, the training of BDP and the classification of test mRNA profiles are carried out jointly in a single analysis. Here, we assume that the number of subtypes with in body fluid do not exceed 5.


To run the analysis at the command line, use the following command:

java -cp ClassifyForensicFluid.jar classify.ClassifyForensicFluid trainSamples_2022_09_22_bayes_bdp_J5.txt


* The ClassifyForensicFluid.jar bundle contains all the compiled java codes that implements classification by BDP, and java 14.0.1 or above is required execute this file.
* classify.ClassifyForensicFluid is the main class to be called in the ClassifyForensicFluid.jar bundle to start the software program for the Bayesian analysis.
* The "trainSamples_2022_09_22_bayes_bdp_J5.txt" file is a text file with two columns that specifies all information and data required for the analysis. Apart from the mRNA profiles data files, i.e., the comma-delimited files mentioned above, this input file also requires some pre-computed inputs to speed up the calculation, which are all the partition configurations for a given marker group, and they are stored in the text files "allPartitionSets5.txt" and "allPartitionSets7.txt."

Shortly after running the above command, a text file, "testSamplesBin_2022_09_22_bayes_bdp_J5_all.log" will be produced, and  the posterior samples simulated by MCMC is stored in this file. 
For this example, thinning is applied to save space, and only every 10000th sample is recorded.

Once the analysis is completed, we can use the "testSamplesBin_2022_09_22_bayes_bdp_J5_all.log" file to plot the posterior distribution of the subtypes (see Section 3 below).

# Section 2: Classification of Forensic Body Fluids by Cut-Model Inference

This example again uses the 46 test mRNA profiles in Section 1, but here, they are classified jointly using the BDP in Cut-Model inference. Therefore, the analysis consists of two stages.

## Section 2.1: Stage 1 of Cut-Model Inference:

In stage 1, we train the BDP using the training data only. The training data of 321 profiles is the same as in Section 1. We assume that the number of subtypes with in body fluid do not exceed 5.

To perform stage 1 of the Cut-Model analysis at the command line, use the following command:


java -cp ClassifyForensicFluid.jar classify.ClassifyForensicFluid trainSamples_2022_09_22_bayes_bdp_J5.txt

* ClassifyForensicFluid.jar and classify.ClassifyForensicFluid are the same as in Section 1.
* The "trainSamples_2022_09_22_bayes_bdp_J5.txt" file is a text file with two columns that specifies all information and data required for stage 1 of the analysis. The key difference between this text file and "trainSamples_2022_09_22_bayes_bdp_J5.txt" in Section 1 is that "trainSamples_2022_09_22_bayes_bdp_J5.txt" must only specifies the training profile datas files, so provides no information on the unlabelled profiles to be classified.

This analysis produces an output file called "trainSamples_2022_09_22_bayes_bdp_J5.log," which contains posterior samples of the subtype clustering for each fluid type given the training data. This serves as the _main chain_ of the stage 2 of the Cut-Model analysis.

## Section 2.2: Stage 2 of Cut-Model Inference:

In stage 2, we fix the subtype clustering of the training profiles to the posterior distribution obtain in stage 1. Then, given this posterior, we infer the fluid type of the 46 test profiles jointly using Gibb sampling.

To perform stage 2 of the Cut-Model analysis at the command line, run the following command:

java -cp ClassifyForensicFluid.jar classify.ClassifyForensicFluidCutModel testSamplesBin_2022_09_22_cut_bdp_J5_all.txt

* ClassifyForensicFluid.jar is the same as Section 1.
* classify.ClassifyForensicFluidCutModel is the main class to be called in the ClassifyForensicFluid.jar bundle to start the software program for stage two of the Cut-Model analysis.
* The "testSamplesBin_2022_09_22_cut_bdp_J5_all.txt" file is a text file with two columns that specifies all information and data required to execute the analysis. Therefore, it includes comma-delimited files for the test and training mRNA profile data, as well as pre-computed input files ("allPartitionSets5.txt" and "allPartitionSets7.txt") to speed up the calculation as in the Bayesian analysis.

The output file "testSamplesBin_2022_09_22_cut_bdp_J5_all.log" is produced, when running the command line presented earlier in this section. This contains the Cut-Model posterior samples of the classification of the test mRNA profiles, allowing us to  plot the posterior distribution of the subtypes (see Section 3 below).
