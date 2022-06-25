package scripts;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

public class AllPartitionSets {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<>();
        int obsCount = 4;
        for(int i=0; i < obsCount; i++) {
            list.add(i);
        }

        try {
            PrintWriter partWriter = new PrintWriter("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets4.txt");
            int cnt = 0;
            for (int i = 1; i <= list.size(); i++) {
                List<List<List<Integer>>> ret = helper(list, i);
                cnt += ret.size();
                for (int j = 0; j < ret.size(); j++) {
                    partWriter.println(ret.get(j));
                }


            }
            partWriter.close();
            System.out.println("Number of partitions: " + cnt);
        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }

    // partition f(n, m)
    private static List<List<List<Integer>>> helper(List<Integer> ori, int m) {
        List<List<List<Integer>>> ret = new ArrayList<>();
        if(ori.size() < m || m < 1) return ret;

        if(m == 1) {
            List<List<Integer>> partition = new ArrayList<>();
            partition.add(new ArrayList<>(ori));
            ret.add(partition);
            return ret;
        }

        // f(n-1, m)
        List<List<List<Integer>>> prev1 = helper(ori.subList(0, ori.size() - 1), m);
        for(int i=0; i<prev1.size(); i++) {
            for(int j=0; j<prev1.get(i).size(); j++) {
                // Deep copy from prev1.get(i) to l
                List<List<Integer>> l = new ArrayList<>();
                for(List<Integer> inner : prev1.get(i)) {
                    l.add(new ArrayList<>(inner));
                }

                l.get(j).add(ori.get(ori.size()-1));
                ret.add(l);
            }
        }

        List<Integer> set = new ArrayList<>();
        set.add(ori.get(ori.size() - 1));
        // f(n-1, m-1)
        List<List<List<Integer>>> prev2 = helper(ori.subList(0, ori.size() - 1), m - 1);
        for(int i=0; i<prev2.size(); i++) {
            List<List<Integer>> l = new ArrayList<>(prev2.get(i));
            l.add(set);
            ret.add(l);
        }

        return ret;
    }
}
