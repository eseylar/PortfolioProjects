*From Danny Ma's [8 Week SQL Challenge - Case Study #1](https://8weeksqlchallenge.com/case-study-1/)*

![*From Danny Ma's [8 Week SQL Challenge - Case Study #1](https://8weeksqlchallenge.com/case-study-1/)*
](https://8weeksqlchallenge.com/images/case-study-designs/1.png)

## Problem Statement

Danny wants to use the data to answer a few simple questions about the customers at his restaurant, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. 

Danny has shared 3 key datasets for this case study:

-   `sales`
-   `menu` 
-   `members`

### Table 1: sales

The `sales` table captures all `customer_id` level purchases with an corresponding `order_date` and `product_id` information for when and what menu items were ordered.

### Table 2: menu

The `menu` table maps the `product_id` to the actual `product_name` and `price` of each menu item.

### Table 3: members

The final `members` table captures the `join_date` when a `customer_id` joined the beta version of the Danny’s Diner loyalty program.

## Case Study Questions

Each of the following case study questions can be answered using a single SQL statement:

1.  What is the total amount each customer spent at the restaurant?
2.  How many days has each customer visited the restaurant?
3.  What was the first item from the menu purchased by each customer?
4.  What is the most purchased item on the menu and how many times was it purchased by all customers?
5.  Which item was the most popular for each customer?
6.  Which item was purchased first by the customer after they became a member?
7.  Which item was purchased just before the customer became a member?
8.  What is the total items and amount spent for each member before they became a member?
9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10.  In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Bonus Questions

### Join All The Things

The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.

Recreate the following table output using the available data:
<table>  <thead>  <tr>  <th>customer_id</th>  <th>order_date</th>  <th>product_name</th>  <th>price</th>  <th>member</th>  </tr>  </thead>  <tbody>  <tr>  <td>A</td>  <td>2021-01-01</td>  <td>curry</td>  <td>15</td>  <td>N</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-01</td>  <td>sushi</td>  <td>10</td>  <td>N</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-07</td>  <td>curry</td>  <td>15</td>  <td>Y</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-10</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-11</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-11</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-01</td>  <td>curry</td>  <td>15</td>  <td>N</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-02</td>  <td>curry</td>  <td>15</td>  <td>N</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-04</td>  <td>sushi</td>  <td>10</td>  <td>N</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-11</td>  <td>sushi</td>  <td>10</td>  <td>Y</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-16</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  </tr>  <tr>  <td>B</td>  <td>2021-02-01</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  </tr>  <tr>  <td>C</td>  <td>2021-01-01</td>  <td>ramen</td>  <td>12</td>  <td>N</td>  </tr>  <tr>  <td>C</td>  <td>2021-01-01</td>  <td>ramen</td>  <td>12</td>  <td>N</td>  </tr>  <tr>  <td>C</td>  <td>2021-01-07</td>  <td>ramen</td>  <td>12</td>  <td>N</td>  </tr>  </tbody>  </table>


### Rank All The Things

Danny also requires further information about the `ranking` of customer products, but he purposely does not need the ranking for non-member purchases so he expects null `ranking` values for the records when customers are not yet part of the loyalty program.
<table>  <thead>  <tr>  <th>customer_id</th>  <th>order_date</th>  <th>product_name</th>  <th>price</th>  <th>member</th>  <th>ranking</th>  </tr>  </thead>  <tbody>  <tr>  <td>A</td>  <td>2021-01-01</td>  <td>curry</td>  <td>15</td>  <td>N</td>  <td>null</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-01</td>  <td>sushi</td>  <td>10</td>  <td>N</td>  <td>null</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-07</td>  <td>curry</td>  <td>15</td>  <td>Y</td>  <td>1</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-10</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  <td>2</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-11</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  <td>3</td>  </tr>  <tr>  <td>A</td>  <td>2021-01-11</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  <td>3</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-01</td>  <td>curry</td>  <td>15</td>  <td>N</td>  <td>null</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-02</td>  <td>curry</td>  <td>15</td>  <td>N</td>  <td>null</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-04</td>  <td>sushi</td>  <td>10</td>  <td>N</td>  <td>null</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-11</td>  <td>sushi</td>  <td>10</td>  <td>Y</td>  <td>1</td>  </tr>  <tr>  <td>B</td>  <td>2021-01-16</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  <td>2</td>  </tr>  <tr>  <td>B</td>  <td>2021-02-01</td>  <td>ramen</td>  <td>12</td>  <td>Y</td>  <td>3</td>  </tr>  <tr>  <td>C</td>  <td>2021-01-01</td>  <td>ramen</td>  <td>12</td>  <td>N</td>  <td>null</td>  </tr>  <tr>  <td>C</td>  <td>2021-01-01</td>  <td>ramen</td>  <td>12</td>  <td>N</td>  <td>null</td>  </tr>  <tr>  <td>C</td>  <td>2021-01-07</td>  <td>ramen</td>  <td>12</td>  <td>N</td>  <td>null</td>  </tr>  </tbody>  </table>
