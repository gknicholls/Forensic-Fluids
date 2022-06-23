package utils;

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


}
