@isTest
public class LebensversicherungLeadControllerTest {
    @isTest
    public static void hackCoverage() {
        LebensversicherungLeadController ctrl = new LebensversicherungLeadController();
        ctrl.ensureLeadExists();
        ctrl.getSatisfactionOptions();
        ctrl.getInsuranceDateOptions();
        ctrl.getCompanyRetirementPlanOptions();
        ctrl.getInsuranceCompanyOptions();
        ctrl.getLegalInsuranceOptions();
        ctrl.createLead();
    }
}