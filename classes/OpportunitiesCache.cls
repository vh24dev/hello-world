public interface OpportunitiesCache {
	void putInTemp(Opportunity[] opps);
    ID[] getOnClaim();
    void swapCurrentWithTemp();
    void clearAll();
}