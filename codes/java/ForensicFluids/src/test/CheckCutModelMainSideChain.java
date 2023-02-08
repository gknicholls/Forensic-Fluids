package test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class CheckCutModelMainSideChain {
    public static void main(String[] args){
        String mainFile = "/Users/chwu/Documents/research/bfc/analysis/2023_02_07/loocvCut_cvf_1.log";
        String sideFile = "/Users/chwu/Documents/research/bfc/analysis/2023_02_07/loocvCut_side_cvf_1.log";

        try{
            BufferedReader mainReader = new BufferedReader(new FileReader(mainFile));
            BufferedReader sideReader = new BufferedReader(new FileReader(sideFile));
            String mainLine = mainReader.readLine();
            String sideLine = sideReader.readLine();
            String[] mainElt = mainLine.split("\t");
            String[] sideElt = sideLine.split("\t");
            int mainClusterColIndex = findColIndex(mainElt, "typeList");
            int sideClusterColIndex = findColIndex(sideElt, "typeList");

            String mainCluster;
            String sideClusterUnknownRemoved;
            List<String> mainSets, sideSets;
            while((mainLine = mainReader.readLine()) != null){
                sideLine = sideReader.readLine();
                mainElt = mainLine.split("\t");
                sideElt = sideLine.split("\t");
                sideClusterUnknownRemoved = sideElt[sideClusterColIndex].trim().replace(",320", "");
                sideClusterUnknownRemoved = sideClusterUnknownRemoved.trim().replace(",[320]", "");
                mainCluster = mainElt[mainClusterColIndex].trim();
                if(!mainCluster.equals(sideClusterUnknownRemoved)){
                    String[] mainClusterElts = mainCluster.split(" ");
                    String m = "";
                    for(int typeIndex = 0; typeIndex < mainClusterElts.length; typeIndex++){
                        mainClusterElts[typeIndex] = mainClusterElts[typeIndex].substring(1, mainClusterElts[typeIndex].length() - 1);
                        mainSets = Arrays.asList(mainClusterElts[typeIndex].replace("],[", "], [").split(", "));
                        Collections.sort(mainSets);
                        for(int setIndex = 0; setIndex < mainSets.size(); setIndex++){
                            m+=mainSets.get(setIndex);
                            if(setIndex != mainSets.size()-1){
                                m += ",";
                            }
                        }
                        m+=" ";
                    }

                    String[] sideClusterElts = sideClusterUnknownRemoved.split(" ");
                    String s = "";
                    for(int typeIndex = 0; typeIndex < sideClusterElts.length; typeIndex++){
                        sideClusterElts[typeIndex] = sideClusterElts[typeIndex].substring(1, sideClusterElts[typeIndex].length() - 1);
                        sideSets = Arrays.asList(sideClusterElts[typeIndex].replace("],[", "], [").split(", "));
                        Collections.sort(sideSets);
                        for(int setIndex = 0; setIndex < sideSets.size(); setIndex++){
                            s += sideSets.get(setIndex);
                            if(setIndex != sideSets.size()-1){
                                s += ",";
                            }
                        }
                        s+=" ";
                    }



                    //System.out.println("main: "+ m);
                    //System.out.println("side: "+ s);
                    if(!m.equals(s)){
                        throw new RuntimeException("Cluster does not match");
                    }
                    //System.out.println("side: "+ sideElt[sideClusterColIndex].trim());
                    //
                }



            }

            mainReader.close();
            sideReader.close();


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    private static int findColIndex(String[] header, String target){

        for(int colIndex = 0; colIndex < header.length; colIndex++){
            if(header[colIndex].trim().equals(target)){
                return colIndex;
            }
        }

        return -1;
    }
}
