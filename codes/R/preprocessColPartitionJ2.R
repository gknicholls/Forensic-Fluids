allParts5Elts = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt",
                     what = character(), sep="\n")
allParts5EltsMDP = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.5obs.mdp.txt",
                     what = character(), sep="\n")
twoParts5EltsIndex = which(unlist(lapply(strsplit(allParts5Elts, split="], [", fixed = T), length)) == 2)
twoParts5Elts = allParts5Elts[twoParts5EltsIndex]
twoParts5EltsMDP = allParts5EltsMDP[twoParts5EltsIndex]

write(twoParts5Elts, 
      file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/twoPartitionSets5.txt",
      sep = "\n")
write(twoParts5EltsMDP, 
      file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.5obs.J2.mdp.txt",
      sep = "\n")

allParts7Elts = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
                     what = character(), sep="\n")
allParts7EltsMDP = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.7obs.mdp.txt",
                        what = character(), sep="\n")
twoParts7EltsIndex = which(unlist(lapply(strsplit(allParts7Elts, split="], [", fixed = T), length)) == 2)
twoParts7Elts = allParts7Elts[twoParts7EltsIndex]
twoParts7EltsMDP = allParts7EltsMDP[twoParts7EltsIndex]

write(twoParts7Elts, 
      file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/twoPartitionSets7.txt",
      sep = "\n")
write(twoParts7EltsMDP, 
      file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.7obs.J2.mdp.txt",
      sep = "\n")