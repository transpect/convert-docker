<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
  
  <p:input port="source"/>
  
  <p:output port="result"/>
  
  <p:insert match="/*" position="first-child">
      <p:input port="insertion">
         <p:inline exclude-inline-prefixes="#all">
            <message>hello!</message>
         </p:inline>
      </p:input>
  </p:insert>
  
</p:declare-step>
