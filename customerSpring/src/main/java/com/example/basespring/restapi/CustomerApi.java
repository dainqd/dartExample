package com.example.basespring.restapi;

import com.example.basespring.dto.CustomerDto;
import com.example.basespring.entities.Customer;
import com.example.basespring.service.CustomerService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/customer")
@RequiredArgsConstructor
public class CustomerApi {
    final CustomerService customerService;

//    @GetMapping()
//    public Page<CustomerDto> getList(
//            @RequestParam(value = "page", required = false, defaultValue = "0") int page,
//            @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
//        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
//        return customerService.findAll(pageable).map(CustomerDto::new);
//    }

    @GetMapping()
    public ResponseEntity<List<Customer>> getList(){
        return ResponseEntity.ok(customerService.findAll());
    }

    @GetMapping("/{id}")
    public CustomerDto getDetail(@PathVariable("id") long id) {
        Optional<Customer> optionalCustomer = customerService.findById(id);
        if (!optionalCustomer.isPresent()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Not found");
        }
        return new CustomerDto(optionalCustomer.get());
    }

    @PostMapping()
    public CustomerDto create(@RequestBody CustomerDto customerDto) {
        return new CustomerDto(customerService.create(customerDto));
    }

    @PutMapping()
    public String update(@RequestBody CustomerDto customerDto) {
        customerService.update(customerDto);
        return "Update success";
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable("id") long id) {
        Optional<Customer> optionalCustomer = customerService.findById(id);
        if (!optionalCustomer.isPresent()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Not found");
        }
        customerService.deleteById(id);
        return new ResponseEntity<>("Delete success", HttpStatus.OK);
    }
}
