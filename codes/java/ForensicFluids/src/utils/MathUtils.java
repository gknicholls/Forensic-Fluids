package utils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Random;

public class MathUtils {
    final private static Random random = new Random();
    public static int[] sample(int count, int start, int end){
        int[] samples = new int[count];
        int index;
        int range = end - start + 1;
        ArrayList<Integer> elts = new ArrayList<Integer>();
        for(int i = 0; i < range; i++){
            elts.add(i);
        }
        for(int countIndex = 0; countIndex < samples.length; countIndex++){
            index = sample(0, elts.size()-1);
            samples[countIndex] = elts.get(index);
            elts.remove(index);
        }
        return samples;

    }

    public static int sample(int start, int end){

        int value = ((int)random.nextInt(end+1)) + start;
        return value;
    }

    public static ArrayList<Integer>[][] getCluster(String file, int lineCount){
        try{

            BufferedReader clustReader = new BufferedReader(new FileReader(file));
            String line = "";
            String[] clustStr;
            String[] obsInClust;
            ArrayList<Integer>[][] clusts = (ArrayList<Integer>[][]) new ArrayList[lineCount][];

            for(int lineIndex = 0; lineIndex < lineCount; lineIndex++){
                line = clustReader.readLine().trim();
                line = line.substring(1, line.length() - 1);

                if(line.contains("], [")){
                    clustStr = line.split("\\], \\[");
                }else{
                    clustStr = new String[]{line};
                }


                clusts[lineIndex] = (ArrayList<Integer>[]) new ArrayList[clustStr.length];
                for(int clustIndex = 0; clustIndex < clustStr.length; clustIndex++){
                    obsInClust = clustStr[clustIndex].replaceAll("\\[|\\]", "").split(", ");

                    clusts[lineIndex][clustIndex] = new ArrayList<Integer>();
                    for(int obsIndex = 0; obsIndex < obsInClust.length; obsIndex++){
                        //System.out.println("elt"+obsInClust[obsIndex]);
                        clusts[lineIndex][clustIndex].add(Integer.parseInt(obsInClust[obsIndex]));

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
