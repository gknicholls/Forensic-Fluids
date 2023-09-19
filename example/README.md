# Section 1: Classification of Forensic Body Fluids by Bayesian Inference

In this example, 46 test mRNA profiles (saved in the comma-delimited file, testSamplesBin_2022_09_22_unknown.csv) are classified by jointly using the BDP in Bayesian inference.

The BDP is trained using labeled 321 labelled mRNA profiles (saved in the following five comma delimited files): 

* 59 cervical fluid profiles (singleBin_cvf.csv)
* 31 menstrual blood profiles (singleBin_mtb.csv)
* 80 saliva profiles (singleBin_slv.csv)
* 65 blood profiles (singleBin_bld.csv)
* 86 semen profiles (singleBin_smn.csv)

In the Bayesian inference set up, the training of BDP and the classification of test mRNA profiles are carried out jointly in a single analysis.

Here, we assume that the number of subtypes with in body fluid do not exceed 5.


To run the analysis at the command line, use the following command:

java -cp ClassifyForensicFluid.jar classify.ClassifyForensicFluid trainSamples_2022_09_22_bayes_bdp_J5.txt


* The ClassifyForensicFluid.jar bundle contains all the compiled java codes that implements classification by BDP, and java 14.0.1 or above is required execute this file.
* classify.ClassifyForensicFluid indicates the main class to be called in the ClassifyForensicFluid.jar bundle to start the software program.
* The "trainSamples_2022_09_22_bayes_bdp_J5.txt" file is a text file with two columns that specifies all information and data required for the analysis. Apart from the mRNA profiles data files, i.e., the comma-delimited files mentioned above, this input file also requires some pre-computed inputs to speed up the calculation, which are all the partition configurations for a given marker group, and they are stored in the text files "allPartitionSets5.txt" and "allPartitionSets7.txt."

Shortly after running the above command, a text file, "testSamplesBin_2022_09_22_bayes_bdp_J5_all.log" will be produced, and  the posterior samples simulated by MCMC is stored in this file. 
For this example, thinning is applied to save space, and only every 10000th sample is recorded.

Once the analysis is completed, we can use the "testSamplesBin_2022_09_22_bayes_bdp_J5_all.log" file to plot the posterior distribution of the subtypes (see Section 3 below).


 

