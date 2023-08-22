package com.example.basespring.entities;

import com.example.basespring.dto.CustomerDto;
import com.example.basespring.entities.basic.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.beans.BeanUtils;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "customers")

public class Customer extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String name;
    private String birthday;
    private String address;
    private String phoneNumber;

    public Customer(CustomerDto customerDto) {
        BeanUtils.copyProperties(customerDto, this);
    }
}
