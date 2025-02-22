package com.example.plutocart.repositories;

import com.example.plutocart.entities.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {

    @Transactional
    @Procedure(procedureName = "viewTransactionByAccountId")
    List<Transaction> viewTransactionByAccountId(Integer accountId);

    @Transactional
    @Procedure(procedureName = "viewTransactionByFilter")
    List<Transaction> viewTransactionByFilter(Integer accountId, Integer walletId, Integer month, Integer year);

    @Transactional
    @Procedure(procedureName = "viewTransactionByDebtIdDesc")
    List<Transaction> viewTransactionByDebtIdDesc(Integer debtId);

    @Transactional
    @Procedure(procedureName = "viewTransactionByAccountIdLimitThree")
    List<Transaction> viewTransactionByAccountIdLimitThree(Integer accountId);

    @Transactional
    @Procedure(procedureName = "viewTransactionByAccountIdAndWalletId")
    List<Transaction> viewTransactionByAccountIdAndWalletId(Integer accountId, Integer walletId);

    @Transactional
    @Procedure(procedureName = "viewTransactionByAccountIdAndWalletIdAndTransactionId")
    List<Transaction> viewTransactionByAccountIdAndWalletIdAndTransactionId(Integer accountId, Integer walletId, Integer transactionId);

    @Transactional
    @Query(value = "SELECT * FROM transaction where wallet_id_wallet = :walletId", nativeQuery = true)
    List<Transaction> viewTransactionByWalletId(Integer walletId);

    @Transactional
    @Query(value = "SELECT * FROM transaction where goal_id_goal = :goalId", nativeQuery = true)
    List<Transaction> viewTransactionByGoalId(Integer goalId);

    @Transactional
    @Query(value = "SELECT * FROM transaction where debt_id_debt = :debtId", nativeQuery = true)
    List<Transaction> viewTransactionByDebtId(Integer debtId);

    @Transactional
    @Query(value = "SELECT * FROM transaction where wallet_id_wallet = :walletId and id_transaction = :transactionId", nativeQuery = true)
    Transaction viewTransactionByWalletIdAndTransactionId(Integer walletId, Integer transactionId);

    @Transactional
    @Query(value = "SELECT * FROM transaction where id_transaction = :transactionId", nativeQuery = true)
    Transaction viewTransactionByTransactionId(Integer transactionId);

    @Transactional
    @Procedure(procedureName = "viewTodayIncome")
    BigDecimal viewTodayIncome(Integer accountId, Integer walletId);

    @Transactional
    @Procedure(procedureName = "viewTodayExpense")
    BigDecimal viewTodayExpense(Integer accountId, Integer walletId);

//    @Transactional
//    @Procedure(name = "viewTodayIncomeAndExpense")
//    Optional viewTodayIncomeAndExpense(Integer accountId, Integer walletId);

    @Transactional
    @Modifying
    @Procedure(procedureName = "InsertIntoTransactionByWalletId")
    void InsertIntoTransactionByWalletId(Integer accountId, Integer walletId, BigDecimal stmTransaction, Integer statementType, LocalDateTime dateTransaction,
                                         Integer transactionCategoryId, String description, String imageUrl, Integer debtIdDebt, Integer goalIdGoal);

//    @Transactional
//    @Modifying
//    @Query(value = "UPDATE transaction SET image_url = :imageUrl WHERE id_transaction = :transactionId", nativeQuery = true)
//    void updateImageUrlInTransactionToCloud(String imageUrl, Integer transactionId);

    @Transactional
    @Modifying
    @Procedure(procedureName = "deleteTransactionByTransactionId")
    void deleteTransactionByTransactionId(Integer accountId, Integer transactionId, BigDecimal stmTransaction, String stmType, Integer walletId, Integer goalId, Integer debtId, LocalDateTime transactionDate);

    @Transactional
    @Modifying
    @Procedure(procedureName = "UpdateTransaction")
    void updateTransaction(Integer accountId, Integer walletId, Integer transactionId, BigDecimal stmTransaction, Integer statementType, LocalDateTime dateTransaction,
                           Integer transactionCategoryId, String description, String imageUrl, Integer debtIdDebt, Integer goalIdGoal);
}