package jcsobrino.tddm.uoc.sharetool.common;

import java.util.Random;

/**
 * Created by JoséCarlos on 18/11/2015.
 */
public final class UtilFunctions {

    private static final Random random = new Random();

    private UtilFunctions(){

    }

    public static final Float randomBetween(final Float minFloat, final Float maxFloat){

        return random.nextFloat() * (maxFloat - minFloat) + minFloat;
    }

    public static final Integer randomBetween(final Integer minInteger, final Integer maxInteger){

        return random.nextInt(maxInteger - minInteger) + minInteger;
    }
}
