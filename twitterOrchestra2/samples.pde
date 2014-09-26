String[] sampleNames = { "birds"
};

int getSampleIndex(String sampleName) {
  for (int i=0; i < sampleNames.length; i++)
    if (sampleNames[i].equals(sampleName))
      return i; 
  return -1;
}

