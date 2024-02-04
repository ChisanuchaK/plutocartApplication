package com.example.plutocart.services;


import com.example.plutocart.auth.JwtUtil;
import com.example.plutocart.constants.ResultCode;
import com.example.plutocart.dtos.goal.*;
import com.example.plutocart.entities.Account;
import com.example.plutocart.entities.Goal;
import com.example.plutocart.entities.Transaction;
import com.example.plutocart.exceptions.PlutoCartServiceApiDataNotFound;
import com.example.plutocart.exceptions.PlutoCartServiceApiException;
import com.example.plutocart.exceptions.PlutoCartServiceApiForbidden;
import com.example.plutocart.exceptions.PlutoCartServiceApiInvalidParamException;
import com.example.plutocart.repositories.AccountRepository;
import com.example.plutocart.repositories.GoalRepository;
import com.example.plutocart.repositories.TransactionRepository;
import com.example.plutocart.utils.GenericResponse;
import com.example.plutocart.utils.HelperMethod;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class GoalService {

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
    @Autowired
    ModelMapper modelMapper;

    public GenericResponse getGoalByAccountId(String accountId, String token) throws PlutoCartServiceApiException {
        String userId = JwtUtil.extractUsername(token);
        if (userId == null || !userId.equals(accountId))
            throw new PlutoCartServiceApiForbidden(ResultCode.FORBIDDEN, "invalid account id key");

        GenericResponse response = new GenericResponse();
        Integer acId = globalValidationService.validationAccountId(accountId);

        List<Goal> goalList = goalRepository.viewGoalByAccountId(acId);
        List<GoalDTO> goalResponse = goalList.stream().map(goal -> modelMapper.map(goal, GoalDTO.class)).collect(Collectors.toList());

        response.setData(goalResponse);
        response.setStatus(ResultCode.SUCCESS);
        return response;
    }

    @Transactional
    public GenericResponse insertGoalByAccountId(String accountId, String nameGoal, String amountGoal, String deficit, LocalDateTime endDateGoal, String token) throws PlutoCartServiceApiException {
        String userId = JwtUtil.extractUsername(token);
        if (userId == null || !userId.equals(accountId))
            throw new PlutoCartServiceApiForbidden(ResultCode.FORBIDDEN, "invalid account id key");

        GenericResponse response = new GenericResponse();
        GoalResPostDTO goalResPostDTO = new GoalResPostDTO();

        GReqPostDTO gReqPostDTO = validationCreateGoal(accountId, nameGoal, amountGoal, deficit);

        goalRepository.insertGoalByAccountId(gReqPostDTO.getNameGoal(), gReqPostDTO.getAmountGoal(), gReqPostDTO.getDeficit(), endDateGoal, gReqPostDTO.getAccountId());

        goalResPostDTO.setAcId(gReqPostDTO.getAccountId());
        goalResPostDTO.setNameGoal(gReqPostDTO.getNameGoal());
        goalResPostDTO.setAmountGoal(gReqPostDTO.getAmountGoal());
        goalResPostDTO.setDeficit(gReqPostDTO.getDeficit());
        goalResPostDTO.setEndDateGoal(endDateGoal);
        response.setStatus(ResultCode.SUCCESS);
        response.setData(goalResPostDTO);
        return response;
    }

    public GReqPostDTO validationCreateGoal(String accountId, String nameGoal, String amountGoal, String deficit) throws PlutoCartServiceApiException {
        String acIdTrim = accountId.trim();
        String nGoalTrim = nameGoal.trim();
        String aGoalTrim = amountGoal.trim();
        String defTrim = deficit.trim();

        if (!HelperMethod.isInteger(acIdTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "account id must be number. ");

        Integer acId = Integer.parseInt(acIdTrim);
        Account account = accountRepository.getAccountById(acId);
        if (account == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "account Id " + acIdTrim + " is not created. ");

        if (StringUtils.isEmpty(nGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "name goal must be string. ");

        if (StringUtils.isEmpty(aGoalTrim) || !HelperMethod.isDecimal(aGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "amount goal must be decimal. ");

        BigDecimal aGoal = new BigDecimal(aGoalTrim);

        if (StringUtils.isEmpty(defTrim) || !HelperMethod.isDecimal(defTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "deficit must be decimal. ");

        BigDecimal def = new BigDecimal(defTrim);

        GReqPostDTO gReqPostDTO = new GReqPostDTO();
        gReqPostDTO.setAccountId(acId);
        gReqPostDTO.setNameGoal(nGoalTrim);
        gReqPostDTO.setAmountGoal(aGoal);
        gReqPostDTO.setDeficit(def);
        return gReqPostDTO;
    }

    @Transactional
    public GenericResponse updateGoalByGoalId(String accountId, String goalId, String nameGoal, String amountGoal, String deficit, LocalDateTime endDateGoal, String token) throws PlutoCartServiceApiException {
        String userId = JwtUtil.extractUsername(token);
        if (userId == null || !userId.equals(accountId))
            throw new PlutoCartServiceApiForbidden(ResultCode.FORBIDDEN, "invalid account id key");

        GenericResponse response = new GenericResponse();
        GoalResPostDTO goalResPostDTO = new GoalResPostDTO();
        GReqPostDTO gReqPostDTO = validationUpdateGoal(accountId, goalId, nameGoal, amountGoal, deficit);

        goalRepository.updateGoalByGoalId(gReqPostDTO.getNameGoal(), gReqPostDTO.getAmountGoal(), gReqPostDTO.getDeficit(), endDateGoal, gReqPostDTO.getGoalId(), gReqPostDTO.getTotalDefOfTransactionInGoal());

        goalResPostDTO.setAcId(gReqPostDTO.getAccountId());
        goalResPostDTO.setNameGoal(gReqPostDTO.getNameGoal());
        goalResPostDTO.setAmountGoal(gReqPostDTO.getAmountGoal());
        goalResPostDTO.setDeficit(gReqPostDTO.getDeficit());
        goalResPostDTO.setEndDateGoal(endDateGoal);
        goalResPostDTO.setDescription("Update Success");

        response.setData(goalResPostDTO);
        response.setStatus(ResultCode.SUCCESS);

        return response;
    }

    public GReqPostDTO validationUpdateGoal(String accountId, String goalId, String nameGoal, String amountGoal, String deficit) throws PlutoCartServiceApiException {
        String nGoalTrim = nameGoal.trim();
        String aGoalTrim = amountGoal.trim();
        String defTrim = deficit.trim();
        BigDecimal totalDeficit = new BigDecimal(0.00);

        if (!HelperMethod.isInteger(accountId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "account id must be number. ");

        Integer acId = Integer.parseInt(accountId);
        Account account = accountRepository.getAccountById(acId);
        if (account == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "account Id " + acId + " is not create. ");

        List<Transaction> transactionList = transactionRepository.viewTransactionByAccountId(acId);
        if (!transactionList.isEmpty()) {
            for (Transaction transaction : transactionList) {
                if (transaction.getGoalIdGoal() != null)
                    totalDeficit = totalDeficit.add(transaction.getStmTransaction());
            }
        }

        if (!HelperMethod.isInteger(goalId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "goal id must be number. ");

        Integer goId = Integer.parseInt(goalId);
        Goal goal = goalRepository.viewGoalByGoalId(goId);
        if (goal == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "goal Id " + goId + " is not create. ");

        if (StringUtils.isEmpty(nGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "name goal must be string. ");

        if (StringUtils.isEmpty(aGoalTrim) || !HelperMethod.isDecimal(aGoalTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "amount goal must be decimal. ");

        BigDecimal aGoal = new BigDecimal(aGoalTrim);

        if (StringUtils.isEmpty(defTrim) || !HelperMethod.isDecimal(defTrim))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "deficit must be decimal. ");

        BigDecimal def = new BigDecimal(defTrim);

        GReqPostDTO gReqPostDTO = new GReqPostDTO();
        gReqPostDTO.setAccountId(acId);
        gReqPostDTO.setGoalId(goId);
        gReqPostDTO.setNameGoal(nGoalTrim);
        gReqPostDTO.setAmountGoal(aGoal);
        gReqPostDTO.setDeficit(def);
        gReqPostDTO.setTotalDefOfTransactionInGoal(totalDeficit);
        return gReqPostDTO;
    }


    @Transactional
    public GenericResponse deleteGoalByGoalId(String accountId, String goalId, String token) throws Exception {
        String userId = JwtUtil.extractUsername(token);
        if (userId == null || !userId.equals(accountId))
            throw new PlutoCartServiceApiForbidden(ResultCode.FORBIDDEN, "invalid account id key");

        GenericResponse response = new GenericResponse();
        GResDelDTO gResDelDTO = new GResDelDTO();

        GReqDelDTO gReqDelDTO = validationDeleteGoal(accountId, goalId, token);
        goalRepository.deleteGoalByGoalId(gReqDelDTO.getGoalId());

        gResDelDTO.setAccountId(gReqDelDTO.getAccountId());
        gResDelDTO.setGoalId(gReqDelDTO.getGoalId());
        gResDelDTO.setDescription("Delete Success");

        response.setData(gResDelDTO);
        response.setStatus(ResultCode.SUCCESS);
        return response;
    }

    public GReqDelDTO validationDeleteGoal(String accountId, String goalId, String token) throws Exception {
        String transactionId = null;
        String walletId = null;


        if (!HelperMethod.isInteger(accountId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "account id must be number. ");

        Integer acId = Integer.parseInt(accountId);
        Account account = accountRepository.getAccountById(acId);
        if (account == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "account Id " + acId + " is not create. ");

        if (!HelperMethod.isInteger(goalId))
            throw new PlutoCartServiceApiInvalidParamException(ResultCode.INVALID_PARAM, "goal id must be number. ");

        Integer goId = Integer.parseInt(goalId);
        Goal goal = goalRepository.viewGoalByGoalId(goId);
        if (goal == null)
            throw new PlutoCartServiceApiDataNotFound(ResultCode.DATA_NOT_FOUND, "goal Id " + goId + " is not create. ");

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
