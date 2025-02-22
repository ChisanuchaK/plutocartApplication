package com.example.plutocart.services;

import com.example.plutocart.constants.ResultCode;
import com.example.plutocart.dtos.goal.GReqDelDTO;
import com.example.plutocart.dtos.goal.GReqPostDTO;
import com.example.plutocart.dtos.goal.GReqPutDTO;
import com.example.plutocart.entities.Account;
import com.example.plutocart.entities.Goal;
import com.example.plutocart.entities.Transaction;
import com.example.plutocart.exceptions.PlutoCartServiceApiDataNotFound;
import com.example.plutocart.exceptions.PlutoCartServiceApiException;
import com.example.plutocart.exceptions.PlutoCartServiceApiInvalidParamException;
import com.example.plutocart.repositories.AccountRepository;
import com.example.plutocart.repositories.GoalRepository;
import com.example.plutocart.repositories.TransactionRepository;
import com.example.plutocart.utils.HelperMethod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.List;

@Service
public class GoalValidationService {

    @Autowired
    GoalRepository goalRepository;
    @Autowired
    AccountRepository accountRepository;
    @Autowired
    TransactionRepository transactionRepository;
    @Autowired
    GlobalValidationService globalValidationService;
    @Autowired
    TransactionService transactionService;

    public GReqPostDTO validationCreateGoal(String accountId, String nameGoal, String totalGoal, String collectedMoney) throws PlutoCartServiceApiException {
        String acIdTrim = accountId.trim();
        String nGoalTrim = nameGoal.trim();
        String tGoalTrim = totalGoal.trim();
        String cMTrim = collectedMoney.trim();

        if (!HelperMethod.isInteger(acIdTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "account id must be number. ");

        Integer acId = Integer.parseInt(acIdTrim);
        Account account = accountRepository.getAccountById(acId);
        if (account == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "account id not found. ");

        if (StringUtils.isEmpty(nGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "name goal must be require. ");

        if (nGoalTrim.length() > 45)
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "name goal over maximum length is 45. ");

        if (StringUtils.isEmpty(tGoalTrim) || !HelperMethod.isDecimal(tGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "total goal must be decimal. ");

        BigDecimal aGoal = new BigDecimal(tGoalTrim);

        if (StringUtils.isEmpty(cMTrim) || !HelperMethod.isDecimal(cMTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "collected money must be decimal. ");

        BigDecimal def = new BigDecimal(cMTrim);

        GReqPostDTO gReqPostDTO = new GReqPostDTO();
        gReqPostDTO.setAccountId(acId);
        gReqPostDTO.setNameGoal(nGoalTrim);
        gReqPostDTO.setTotalGoal(aGoal);
        gReqPostDTO.setCollectedMoney(def);
        return gReqPostDTO;
    }

    public GReqPostDTO validationUpdateGoal(String accountId, String goalId, String nameGoal, String totalGoal, String collectedMoney) throws PlutoCartServiceApiException {
        String nGoalTrim = nameGoal.trim();
        String tGoalTrim = totalGoal.trim();
        String cMTrim = collectedMoney.trim();
//        BigDecimal totalCollectedMoney = new BigDecimal(0.00);

        if (!HelperMethod.isInteger(accountId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "account id must be number. ");

        Integer acId = Integer.parseInt(accountId);
        Account account = accountRepository.getAccountById(acId);
        if (account == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "account id is not found. ");

//        List<Transaction> transactionList = transactionRepository.viewTransactionByAccountId(acId);
//        if (!transactionList.isEmpty()) {
//            for (Transaction transaction : transactionList) {
//                if (transaction.getGoalIdGoal() != null)
//                    totalCollectedMoney = totalCollectedMoney.add(transaction.getStmTransaction());
//            }
//        }

        if (!HelperMethod.isInteger(goalId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "goal id must be number. ");

        Integer goId = Integer.parseInt(goalId);
        Goal goal = goalRepository.viewGoalByGoalId(goId);
        if (goal == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "goal id is not found. ");

        if (StringUtils.isEmpty(nGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "name goal must be require. ");

        if (nGoalTrim.length() > 45)
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "name goal over maximum length is 45. ");

        if (StringUtils.isEmpty(tGoalTrim) || !HelperMethod.isDecimal(tGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "total goal must be decimal. ");

        BigDecimal aGoal = new BigDecimal(tGoalTrim);

        if (StringUtils.isEmpty(cMTrim) || !HelperMethod.isDecimal(cMTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "collected money must be decimal. ");

        BigDecimal def = new BigDecimal(cMTrim);

        GReqPostDTO gReqPostDTO = new GReqPostDTO();
        gReqPostDTO.setAccountId(acId);
        gReqPostDTO.setGoalId(goId);
        gReqPostDTO.setNameGoal(nGoalTrim);
        gReqPostDTO.setTotalGoal(aGoal);
        gReqPostDTO.setCollectedMoney(def);
//        gReqPostDTO.setTotalDefOfTransactionInGoal(totalCollectedMoney);
        return gReqPostDTO;
    }

    public GReqPutDTO validationUpdateGoalToComplete(String accountId, String goalId) throws PlutoCartServiceApiException {

        if (!HelperMethod.isInteger(accountId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "account id must be number. ");

        Integer acId = Integer.parseInt(accountId);
        Account account = accountRepository.getAccountById(acId);
        if (account == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "account id is not found. ");

        if (!HelperMethod.isInteger(goalId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "goal id must be number. ");

        Integer goId = Integer.parseInt(goalId);
        Goal goal = goalRepository.viewGoalByGoalId(goId);
        if (goal == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "goal id is not found. ");

        GReqPutDTO gReqPutDTO = new GReqPutDTO();
        gReqPutDTO.setAccountId(acId);
        gReqPutDTO.setGoalId(goId);
        return gReqPutDTO;
    }

    public GReqDelDTO validationDeleteGoal(String accountId, String goalId, String token) throws Exception {
        String transactionId = null;
        String walletId = null;


        if (!HelperMethod.isInteger(accountId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "account id must be number. ");

        Integer acId = Integer.parseInt(accountId);
        Account account = accountRepository.getAccountById(acId);
        if (account == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "account id is not found. ");

        if (!HelperMethod.isInteger(goalId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "goal id must be number. ");

        Integer goId = Integer.parseInt(goalId);
        Goal goal = goalRepository.viewGoalByGoalId(goId);
        if (goal == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "goal id is not found. ");

        List<Transaction> transactionList = transactionRepository.viewTransactionByGoalId(goId);
        if (!transactionList.isEmpty()) {
            for (Transaction transaction : transactionList) {
//                if (transaction.getGoalIdGoal() != null)
                transactionId = String.valueOf(transaction.getId());
                walletId = String.valueOf(transaction.getWalletIdWallet().getWalletId());
                transactionService.deleteTransaction(accountId, walletId, transactionId, token);
//                transactionRepository.deleteTransactionByTransactionId(transaction.getId(), transaction.getStmTransaction(), transaction.getStatementType(), transaction.getWalletIdWallet().getWalletId(), transaction.getGoalIdGoal().getId(), null);
            }
        }

        GReqDelDTO gReqDelDTO = new GReqDelDTO();
        gReqDelDTO.setAccountId(acId);
        gReqDelDTO.setGoalId(goId);
        return gReqDelDTO;
    }

}
