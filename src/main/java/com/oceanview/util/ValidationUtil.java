package com.oceanview.util;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ValidationUtil {

    // Returns a list of error messages — empty list means all valid
    public static List<String> validateReservation(
            String guestName,
            String contactNumber,
            String email,
            String address,
            String roomType,
            String checkInDate,
            String checkOutDate,
            String numGuests) {

        List<String> errors = new ArrayList<>();

        // Guest Name — required, letters and spaces only
        if (isBlank(guestName)) {
            errors.add("Guest full name is required.");
        } else if (!guestName.trim().matches("[\\p{L} .'-]{2,100}")) {
            errors.add("Guest name must be 2–100 characters and contain only letters.");
        }

        // Contact Number — required, digits/spaces/+/- only
        if (isBlank(contactNumber)) {
            errors.add("Contact number is required.");
        } else if (!contactNumber.trim().matches("[\\d\\s+\\-]{7,20}")) {
            errors.add("Contact number must be 7–20 characters (digits, +, - only).");
        }

        // Email — optional but must be valid format if provided
        if (!isBlank(email) && !email.trim().matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
            errors.add("Email address format is invalid.");
        }

        // Address — required
        if (isBlank(address)) {
            errors.add("Home address is required.");
        } else if (address.trim().length() < 5) {
            errors.add("Please enter a complete home address.");
        }

        // Room Type — required
        if (isBlank(roomType)) {
            errors.add("Please select a room type.");
        }

        // Dates — required and logical
        if (isBlank(checkInDate)) {
            errors.add("Check-in date is required.");
        }
        if (isBlank(checkOutDate)) {
            errors.add("Check-out date is required.");
        }

        if (!isBlank(checkInDate) && !isBlank(checkOutDate)) {
            try {
                LocalDate ci = LocalDate.parse(checkInDate);
                LocalDate co = LocalDate.parse(checkOutDate);
                LocalDate today = LocalDate.now();

                if (ci.isBefore(today)) {
                    errors.add("Check-in date cannot be in the past.");
                }
                if (!co.isAfter(ci)) {
                    errors.add("Check-out date must be after check-in date.");
                }
                if (ci.until(co, java.time.temporal.ChronoUnit.DAYS) > 365) {
                    errors.add("Reservation cannot exceed 365 nights.");
                }
            } catch (Exception e) {
                errors.add("Invalid date format. Please use the date picker.");
            }
        }

        // Number of guests — must be 1–4
        if (isBlank(numGuests)) {
            errors.add("Number of guests is required.");
        } else {
            try {
                int n = Integer.parseInt(numGuests);
                if (n < 1 || n > 4) errors.add("Number of guests must be between 1 and 4.");
            } catch (NumberFormatException e) {
                errors.add("Invalid number of guests.");
            }
        }

        return errors;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}