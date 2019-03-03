package org.ff4j.dynamodb;

/*
 * #%L
 * ff4j-store-aws-dynamodb
 * %%
 * Copyright (C) 2013 - 2016 FF4J
 * %%
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * #L%
 */

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import org.ff4j.exception.PropertyAlreadyExistException;
import org.ff4j.exception.PropertyNotFoundException;
import org.ff4j.property.Property;
import org.ff4j.property.store.AbstractPropertyStore;
import org.ff4j.property.store.PropertyStore;
import org.ff4j.utils.Util;

import java.util.Map;
import java.util.Set;

import static org.ff4j.dynamodb.DynamoDBConstants.*;

/**
 *  Implementation of {@link PropertyStore} using Amazon DynamoDB.
 *
 *  @author <a href="mailto:jeromevdl@gmail.com">Jerome VAN DER LINDEN</a>
 */
public class PropertyStoreDynamoDB extends AbstractPropertyStore {

    /**
     * Internal DynamoDB client
     */
    private DynamoDBClient dynamoDBClient;

    /************************************************************************************************************/
    /**                                           CONSTRUCTORS                                                  */
    /************************************************************************************************************/

    /**
     * Default constructor using default DynamoDB client and default table name.
     * If you need more control on AWS connection (credentials, proxy, ...), use {@link #PropertyStoreDynamoDB(AmazonDynamoDB)}
     */
    public PropertyStoreDynamoDB() {
        this(AmazonDynamoDBClientBuilder.defaultClient(), PROPERTY_TABLE_NAME);
    }

    /**
     * Constructor using default DynamoDB client and custom table name.
     * If you need more control on AWS connection (credentials, proxy, ...), use {@link #PropertyStoreDynamoDB(AmazonDynamoDB, String)}
     *
     * @param tableName name of the table to use in DynamoDB
     */
    public PropertyStoreDynamoDB(String tableName) {
        this(AmazonDynamoDBClientBuilder.defaultClient(), tableName);
    }

    /**
     * Constructor using custom DynamoDB client and default table name.
     *
     * @param amazonDynamoDB Amazon DynamoDB client
     */
    public PropertyStoreDynamoDB(AmazonDynamoDB amazonDynamoDB) {
        this(amazonDynamoDB, PROPERTY_TABLE_NAME);
    }

    /**
     * Constructor using custom DynamoDB client and table name.
     *
     * @param amazonDynamoDB Amazon DynamoDB client
     * @param tableName name of the table to use in DynamoDB
     */
    public PropertyStoreDynamoDB(AmazonDynamoDB amazonDynamoDB, String tableName) {
        initStore(amazonDynamoDB, tableName);
    }

    /************************************************************************************************************/
    /**                                              PUBLIC                                                     */
    /************************************************************************************************************/

    /** {@inheritDoc} */
    @Override
    public boolean existProperty(String name) {
        try {
            getClient().getItem(name);
        } catch (PropertyNotFoundException e) {
            return false;
        }
        return true;
    }

    /** {@inheritDoc} */
    @Override
    public <T> void createProperty(Property<T> property) {
        Util.assertNotNull(property);
        Util.assertHasLength(property.getName());
        if (existProperty(property.getName())) {
            throw new PropertyAlreadyExistException(property.getName());
        }

        getClient().putProperty(property);
    }

    /** {@inheritDoc} */
    @Override
    public void updateProperty(String name, String newValue) {
        Util.assertHasLength(name);

        // read property and assign value to check if types are compatible before updating
        Property<?> property = readProperty(name);
        property.setValueFromString(newValue);

        getClient().updateProperty(name, newValue);
    }

    /** {@inheritDoc} */
    @Override
    public Property<?> readProperty(String name) {
        return getClient().getProperty(name);
    }

    /** {@inheritDoc} */
    @Override
    public void deleteProperty(String name) {
        Util.assertHasLength(name);
        if (!existProperty(name)) {
            throw new PropertyNotFoundException(name);
        }
        getClient().deleteProperty(name);
    }

    /** {@inheritDoc} */
    @Override
    public Map<String, Property<?>> readAllProperties() {
        return getClient().getAllProperties();
    }

    /** {@inheritDoc} */
    @Override
    public Set<String> listPropertyNames() {
        return getClient().getAllPropertyNames();
    }

    /** {@inheritDoc} */
    @Override
    public void clear() {
        getClient().deleteTable();
        createSchema();
    }

    /** {@inheritDoc} */
    @Override
    public void createSchema() {
        getClient().createTable();
    }

    /************************************************************************************************************/
    /**                                              PRIVATE                                                    */
    /************************************************************************************************************/

    /**
     * Initialize internal dynamoDB client and create DynamoDB table if necessary
     *
     * @param amazonDynamoDB dynamoDB client
     * @param tableName name of the table in DynamoDB
     */
    private void initStore(AmazonDynamoDB amazonDynamoDB, String tableName) {
        dynamoDBClient = new DynamoDBClient(amazonDynamoDB, tableName);

        if (!getClient().tableExists()) {
            createSchema();
        }
    }

    /**
     * Getter accessor for attribute 'dynamoDBClient'.
     *
     * @return
     *       current value of 'dynamoDBClient'
     */
    private DynamoDBClient getClient() {
        return dynamoDBClient;
    }
}
