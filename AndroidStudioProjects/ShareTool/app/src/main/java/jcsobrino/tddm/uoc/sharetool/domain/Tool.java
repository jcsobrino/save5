package jcsobrino.tddm.uoc.sharetool.domain;

import com.activeandroid.Model;
import com.activeandroid.annotation.Column;
import com.activeandroid.annotation.Table;
import com.example.joscarlos.myapplication.dto.ITool;

/**
 * Created by JoséCarlos on 13/11/2015.
 */
@Table(name = "Tools")
public class Tool extends Model implements ITool {

    @Column(notNull = true)
    private String name;
    @Column(notNull = true)
    private String description;
    @Column(notNull = true)
    private Float pricePerDay;
    @Column(notNull = false)
    private User user;
    @Column(notNull = true)
    private Float positionLat;
    @Column(notNull = true)
    private Float positionLng;
    private String mainImageCode;
    private String[] secondaryImageCodes;
    private Float distanceInMeters;

    public Tool() {
        super();
    }

    public Tool(String name, String description, Float pricePerDay, User user, Float positionLat, Float positionLng, String mainImageCode, String[] secondaryImageCodes) {
        super();
        this.name = name;
        this.description = description;
        this.pricePerDay = pricePerDay;
        this.user = user;
        this.positionLat = positionLat;
        this.positionLng = positionLng;
        this.mainImageCode = mainImageCode;
        this.secondaryImageCodes = secondaryImageCodes;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public Float getPricePerDay() {
        return pricePerDay;
    }

    @Override
    public void setPricePerDay(Float pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    @Override
    public User getUser() {
        return user;
    }

    @Override
    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public Float getPositionLat() {
        return positionLat;
    }

    @Override
    public void setPositionLat(Float positionLat) {
        this.positionLat = positionLat;
    }

    @Override
    public Float getPositionLng() {
        return positionLng;
    }

    @Override
    public void setPositionLng(Float positionLng) {
        this.positionLng = positionLng;
    }

    @Override
    public String getMainImageCode() {
        return mainImageCode;
    }

    @Override
    public void setMainImageCode(String mainImageCode) {
        this.mainImageCode = mainImageCode;
    }

    @Override
    public String[] getSecondaryImageCodes() {
        return secondaryImageCodes;
    }

    @Override
    public void setSecondaryImageCodes(String[] secondaryImageCodes) {
        this.secondaryImageCodes = secondaryImageCodes;
    }

    @Override
    public Float getDistanceInMeters() {
        return distanceInMeters;
    }

    public void setDistanceInMeters(Float distanceInMeters) {
        this.distanceInMeters = distanceInMeters;
    }
}
