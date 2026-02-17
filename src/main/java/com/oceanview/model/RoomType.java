package com.oceanview.model;

import java.math.BigDecimal;

public class RoomType {
    private int id;
    private String typeName;
    private String description;
    private BigDecimal pricePerNight;
    private int maxGuests;

    public RoomType() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }

    public int getMaxGuests() { return maxGuests; }
    public void setMaxGuests(int maxGuests) { this.maxGuests = maxGuests; }
}
