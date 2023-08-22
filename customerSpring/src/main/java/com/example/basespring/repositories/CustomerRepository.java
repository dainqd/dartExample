package com.example.basespring.repositories;

import com.example.basespring.entities.Customer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Page<Customer> findAll(Pageable pageable);

    Optional<Customer> findById(Long id);
}
