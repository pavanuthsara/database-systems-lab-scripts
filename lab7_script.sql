--use microsoft sql server studio to execute those queries

CREATE DATABASE DS_LAB7;
USE DS_LAB7;


CREATE TABLE AdminDocs(
	id INT PRIMARY KEY,
	xDoc XML NOT NULL --Untyped XML column in table
);

SELECT * FROM AdminDocs;

--inserting data into Untyped XML column
INSERT INTO AdminDocs VALUES (6,
'<catalog>
	<product dept="WMN">
		<number>557</number>
		<name language="en">Fleece Pullover</name>
		<colorChoices>navy black</colorChoices>
	</product>
	 <product dept="ACC">
		 <number>563</number>
		 <name language="en">Floppy Sun Hat</name>
	 </product>
	 <product dept="ACC">
		 <number>443</number>
		 <name language="en">Deluxe Travel Bag</name>
	 </product>
	 <product dept="MEN">
		 <number>784</number>
		 <name language="en">Cotton Dress Shirt</name>
		 <colorChoices>white gray</colorChoices>
		 <desc>Our <i>favorite</i> shirt!</desc>
	 </product>
</catalog>');

INSERT INTO AdminDocs VALUES (2,
'<doc id="123">
	 <sections>
	 <section num="1"><title>XML Schema</title></section>
	 <section num="3"><title>Benefits</title></section>
	 <section num="4"><title>Features</title></section>
	 </sections>
</doc>');

--using Query() method
SELECT id, xDoc.query('/catalog')
FROM AdminDocs;

SELECT id, xDoc.query('/catalog/product')
FROM AdminDocs;

-- '//product' means search anywhere in the XML document for nodes named <product>
-- then it returns XML fragments
SELECT id, xDoc.query('//product')
FROM AdminDocs;

-- '/*/product' finds <product> only if it's a direct child of the root element
-- /* referes to root element
SELECT id, xDoc.query('/*/product')
FROM AdminDocs;

-- filter by attribute name "WMN"
SELECT id, xDoc.query('/*/product[@dept="WMN"]')
FROM AdminDocs;

-- '/child::product' -> select <product> elements that are direct children of the root
-- '[attribute::dept="WMN"]' -> filder predicate (select <product> elements whose dept="WMN"
SELECT id, xDoc.query('/*/child::product[attribute::dept="WMN"]')
FROM AdminDocs

-- search anywhere in the document //product
-- dept="WMN" looking for child element <dept>, not an attribute
-- no xml output for following query
SELECT id, xDoc.query('//product[dept="WMN"]')
FROM AdminDocs;

-- descendant-or-self::product -> select all <product> elements that are at any depth including the node itself
SELECT id, xDoc.query('descendant-or-self::product[attribute::dept="WMN"]')
FROM AdminDocs;

-- this filters <number> element (inside <product>) which greater than 500
SELECT id, xDoc.query('//product[number>500]')
FROM AdminDocs
WHERE id=6;

-- following outputs only <number> elements that fulfill the condition
SELECT id, xDoc.query('//product/number[. gt 500]')
FROM AdminDocs
WHERE id=6;

-- outputs the 4th <product> element inside <catalog>
SELECT id, xDoc.query('/catalog/product[4]')
FROM AdminDocs
WHERE id=6;

-- filter by two conditions
SELECT id, xDoc.query('//product[number>500][@dept="ACC"]')
FROM AdminDocs
WHERE id=6;

SELECT id, xDoc.query('//product[number>500][1]')
FROM AdminDocs
WHERE id=6;

-- therum ganimai wedagath
SELECT xDoc.query('for $prod in //product
						let $x:=$prod/number
						return $x')
FROM AdminDocs
WHERE id=6;

SELECT xDoc.query('for $prod in //product
						let $x:=$prod/number
						where $x>500
						return $x')
FROM AdminDocs
WHERE id=6;

SELECT xDoc.query('for $prod in //product
						let $x:=$prod/number
						where $x>500
						return (<item>{$x}</item>)')
FROM AdminDocs
WHERE id=6;

-- outputs data without <number> tag
SELECT xDoc.query('for $prod in //product
						let $x:=$prod/number
						where $x>500
						return (<item>{data($x)}</item>)')
FROM AdminDocs
WHERE id=6;

SELECT xDoc.query('for $prod in //product
						let $x:=$prod/number
						return if ($x>500)
						then <book>{data($x)}</book>
						else <paper>{data($x)}</paper>')
FROM AdminDocs
WHERE id=6;

-- using Exist() method
-- Exist() mehtod returns 1 if the XQuery finds at leat one matching node, otherwise returns 0
SELECT id
FROM AdminDocs
WHERE xDoc.exist('/doc[@id=123]')=1;

-- value(XQuery, SQLType) extracts a scalar value from XML
-- .query() returns XML fragment, .value() returns plain text/number
-- we have to use [1] because .value() can only return one value
SELECT xDoc.value('(/doc//section[@num = 3]/title)[1]', 'varchar(100)')
FROM AdminDocs;

-- insertion of subtree into XML database
SELECT * 
FROM AdminDocs
WHERE id=2;

UPDATE AdminDocs SET xDoc.modify('
	insert
		<section num="2">
			<title>Background</title>
		</section>
	after (/doc//section[@num=1])[1]');









