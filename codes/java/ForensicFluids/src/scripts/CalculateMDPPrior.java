package scripts;

import model.ClusterPrior;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;

public class CalculateMDPPrior {
    public static void main(String[] args){
        String allPartitionSets10File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets10.txt";
        //String allPartitionSets3File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets3.txt";
        //String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        //String allPartitionSets4File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets4.txt";
        //String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        int totalPartsCount = 115975;
        //int totalPartsCount = 877;
        int[][][] partitions = getClusterArray(allPartitionSets10File, totalPartsCount);
        double alpha = 20;
        int maxSetCount = 5;
        int totalObsCount = 10;
        double[] mdpProb = new double[totalPartsCount];

        for (int partIndex = 0; partIndex < partitions.length; partIndex++) {
            mdpProb[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha,
                    maxSetCount,
                    partitions[partIndex],
                    totalObsCount);
            if(partIndex%1000 == 0){
                System.out.println(partIndex);
            }


        }

        try{
            PrintWriter writer = new PrintWriter("/Users/chwu/Documents/research/bfc/output/ex.10obs.mdp_obsMoreJ5.txt");
            for(int i = 0; i < mdpProb.length; i++){
                writer.println(mdpProb[i]);
            }
            writer.close();
        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    private static int[][][] getClusterArray(String file, int lineCount){
        try{

            BufferedReader clustReader = new BufferedReader(new FileReader(file));
            String line = "";
            String[] clustStr;
            String[] obsInClust;
            int[][][] clusts = new int[lineCount][][];

            for(int lineIndex = 0; lineIndex < lineCount; lineIndex++){

                line = clustReader.readLine().trim();
                line = line.substring(1, line.length() - 1);

                if(line.contains("], [")){
                    clustStr = line.split("\\], \\[");
                }else{
                    clustStr = new String[]{line};
                }


                clusts[lineIndex] = new int[clustStr.length][];
                for(int clustIndex = 0; clustIndex < clustStr.length; clustIndex++){
                    obsInClust = clustStr[clustIndex].replaceAll("\\[|\\]", "").split(", ");

                    clusts[lineIndex][clustIndex] = new int[obsInClust.length];
                    for(int obsIndex = 0; obsIndex < obsInClust.length; obsIndex++){

                        clusts[lineIndex][clustIndex][obsIndex] = Integer.parseInt(obsInClust[obsIndex]) - 1;

                    }
                }
            }

            clustReader.close();

            return clusts;

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }
}
