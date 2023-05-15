drop function ListOrders;
CREATE OR REPLACE procedure
ListOrders(customer_id in
varchar2)
as
cursor cus is
SELECT *
FROM ORDERS ord
WHERE ord.CUST = customer_id;
  ans number:=0; 
begin 
  for p in cur
    loop
    dbms_output.put_line(p.order_num||'  '||p.order_date||'  '||p.cust);
    ans:=ans+p.amount;
    end loop;
  return ans;
exception 
    when others 
        then dbms_output.put_line('GC error: '||sqlerrm); 
end ListOrders; 
 
declare 
ans number; 
begin 
 ListOrdersForCustomer(2108);  
 dbms_output.put_line('ans  ='||'  '||ans);
end;





CREATE OR REPLACE PROCEDURE getOrdersAndSumByCustomer(customer_id in
varchar2)
as
cursor cus is
SELECT *
FROM ORDERS ord
WHERE ord.CUST = customer_id;
price_sum number := 0;
begin
for q_order in cus
loop
dbms_output.put_line(q_order.ORDER_NUM || ' ' || q_order.ORDER_DATE || ' ' ||
q_order.AMOUNT);
price_sum := price_sum + q_order.AMOUNT;
end loop;
dbms_output.put_line('price sum: ' || price_sum);
exception
when NO_DATA_FOUND--wont ever be achieved
then dbms_output.put_line('no data found');
when others
then dbms_output.put_line(sqlerrm);
end;
begin
GetOrdersAndSumByCustomer(2108);
end;





