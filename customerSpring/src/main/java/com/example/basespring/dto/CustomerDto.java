package com.example.basespring.dto;

import com.example.basespring.entities.Customer;
import lombok.*;
import org.springframework.beans.BeanUtils;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class CustomerDto {
    private long id;
    private String name;
    private String birthday;
    private String address;
    private String phoneNumber;

    public CustomerDto(Customer customer) {
        BeanUtils.copyProperties(customer, this);
    }
}
