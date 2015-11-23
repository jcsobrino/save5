package jcsobrino.tddm.uoc.sharetool.common;

/**
 * Created by JoséCarlos on 13/11/2015.
 */
public enum ToolOrderEnum {

    MIN_PRICE("pricePerDay asc"), NEAR_TOOL("name");

    private String value;

    ToolOrderEnum(final String value){

        this.value = value;
    }

    public String getValue(){
        return value;
    }
}
