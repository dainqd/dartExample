package com.example.basespring.service;

import com.example.basespring.dto.CustomerDto;
import com.example.basespring.entities.Customer;
import com.example.basespring.repositories.CustomerRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomerService {
    final CustomerRepository customerRepository;

//    public Page<Customer> findAll(Pageable pageable) {
//        return customerRepository.findAll(pageable);
//    }

    public List<Customer> findAll() {
        return customerRepository.findAll();
    }
    
    public Optional<Customer> findById(long id) {
        return customerRepository.findById(id);
    }

    public Customer create(CustomerDto customerDto) {
        Customer customer = new Customer(customerDto);
        BeanUtils.copyProperties(customerDto, customer);
        customer.setCreatedAt(LocalDateTime.now());
        return customerRepository.save(customer);
    }

    public void update(CustomerDto customerDto) {
        Optional<Customer> optionalCustomer = customerRepository.findById(customerDto.getId());
        if (!optionalCustomer.isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Not found");
        }
        Customer customer = optionalCustomer.get();

        BeanUtils.copyProperties(customerDto, customer);
        customerRepository.save(customer);
    }

    public void deleteById(long id) {
        customerRepository.deleteById(id);
    }
}
