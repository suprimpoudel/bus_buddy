package com.np.suprimpoudel.bus_buddy;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan
public class BusBuddyApplication {

	public static void main(String[] args) {
		SpringApplication.run(BusBuddyApplication.class, args);
	}

}
