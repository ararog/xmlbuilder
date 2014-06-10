{
  Copyright 2008 James Murty (www.jamesmurty.com)
  Copyright 2009 Rogerio Araújo (faces.eti.br)
 
  Licensed under the Apache License, Version 2.0 (the "License"); 
  you may not use this file except in compliance with the License. 
  You may obtain a copy of the License at 
  
  http://www.apache.org/licenses/LICENSE-2.0 
  
  Unless required by applicable law or agreed to in writing, software 
  distributed under the License is distributed on an "AS IS" BASIS, 
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
  See the License for the specific language governing permissions and 
  limitations under the License.
  
  
  This code is available from the Google Code repository at:
  http://xmlbuilder.codeplex.com
}
namespace DSL.Builder;

interface

uses
  System.Text,
  System.IO,
  System.Xml;

type
  XMLBuilder = public class
  private
      class var
        _xmlDocument: XmlDocument;
        _xmlElement: XmlElement;

  protected
    constructor(document : XmlDocument);
    constructor(myElement : XmlElement; parentElement : XmlElement);

  public
    class method Start(name: String): XMLBuilder; 

    method AddXmlDeclaration(version: String; encoding: String; standalone: String);
    method AddDocumentType(name: String; publicId: String; systemId: String);

    method GetElement() : XmlElement; 
    method GetRoot() : XMLBuilder;
    method GetDocument() : XmlDocument;

    method Element(name: String) : XMLBuilder;
    method Elem(name: String) : XMLBuilder;
    method E(name: String) : XMLBuilder;

    method Attribute(name: String; value: String) : XMLBuilder;
    method Attr(name: String; value: String) : XMLBuilder;
    method A(name: String; value: String) : XMLBuilder;

    method Text(value: String) : XMLBuilder;
    method T(value: String) : XMLBuilder;

    method Cdata(value: array of Byte) : XMLBuilder;
    method Data(value: array of Byte) : XMLBuilder;
    method D(value: array of Byte) : XMLBuilder;

    method Comment(value: String) : XMLBuilder; 
    method Cmnt(value: String) : XMLBuilder;
    method C(value: String) : XMLBuilder;

    method Instruction(target: String; value: String) : XMLBuilder;
    method Inst(target: String ; value: String) : XMLBuilder;
    method I(target: String; value: String) : XMLBuilder;

    method Reference(name: String) : XMLBuilder;
    method Ref(name: String) : XMLBuilder; 
    method R(name: String ) : XMLBuilder;

    method Up(steps : Integer ) : XMLBuilder;
    method Up() : XMLBuilder;

    method ToWriter(writer: XmlTextWriter);
    method AsString() : String;
  end;
  
implementation

constructor XMLBuilder(document : XmlDocument);
begin   
    self._xmlDocument := document;
    self._xmlElement := document.DocumentElement;
end;

constructor XMLBuilder(myElement : XmlElement; parentElement : XmlElement);
begin
    self._xmlElement := myElement;
    self._xmlDocument := myElement.OwnerDocument;
    if parentElement <> nil then begin
    	parentElement.AppendChild(myElement);
    end;
end;

class method XMLBuilder.Start(name: String): XMLBuilder; 
var
    document: XmlDocument;
    rootElement: XmlElement;

begin
    document := new XmlDocument();
    rootElement := document.CreateElement(name);
    document.AppendChild(rootElement);
    Result := new XMLBuilder(document);
end;

method XMLBuilder.AddXmlDeclaration(version: String; encoding: String; standalone: String);
begin
    var xmlDecl: XmlDeclaration := self._xmlDocument.CreateXmlDeclaration(version, encoding, standalone);
    self._xmlDocument.InsertBefore(xmlDecl, self._xmlDocument.DocumentElement);
end;

method XMLBuilder.AddDocumentType(name: String; publicId: String; systemId: String);
begin
    var docType: XmlDocumentType := self._xmlDocument.CreateDocumentType(name, publicId, systemId, nil);
    self._xmlDocument.InsertBefore(docType, self._xmlDocument.DocumentElement);
end;

method XMLBuilder.GetElement(): XmlElement; 
begin
    Result := self._xmlElement;
end;

method XMLBuilder.GetRoot(): XMLBuilder;
begin
    Result := new XMLBuilder(self.GetDocument());
end;

method XMLBuilder.GetDocument() : XmlDocument;
begin 
	Result := self._xmlDocument;
end;

method XMLBuilder.Element(name: String) : XMLBuilder;
var
    textNode: XmlNode := nil;
    childNodes: XmlNodeList := _xmlElement.ChildNodes;

begin

    for _i: Integer := 0 to childNodes.Count -1 step 1 do begin
        if (XmlNodeType.Text.Equals(childNodes.Item(_i).NodeType)) then begin
            textNode := childNodes.Item(_i);
            break;
        end;
    end;

    if (textNode <> nil) then begin
        raise new Exception("Cannot add sub-element <" +
            name + "> to element <" + self._xmlElement.Name 
            + "> that already contains the Text node: " + textNode);
    end;
    
    Result := new XMLBuilder(GetDocument().CreateElement(name), self._xmlElement);
end;

method XMLBuilder.Elem(name: String) : XMLBuilder;
begin
    Result := self.Element(name); 
end;

method XMLBuilder.E(name: String) : XMLBuilder;
begin
    Result := self.Element(name); 
end;

method XMLBuilder.Attribute(name: String; value: String) : XMLBuilder;
begin
    var _attribute : XmlAttribute := self._xmlDocument.CreateAttribute(name);
    _attribute.Value := value;
    self._xmlElement.Attributes.Append(_attribute);
    Result := self;
end;

method XMLBuilder.Attr(name: String; value: String) : XMLBuilder;
begin
    Result := self.Attribute(name, value); 
end;

method XMLBuilder.A(name: String; value: String) : XMLBuilder;
begin
    Result := self.Attribute(name, value); 
end;

method XMLBuilder.Text(value: String) : XMLBuilder;
begin
    self._xmlElement.AppendChild(GetDocument().CreateTextNode(value));
    Result := self;
end;

method XMLBuilder.T(value: String) : XMLBuilder;
begin
    Result := self.Text(value);
end;

method XMLBuilder.Cdata(value: array of Byte) : XMLBuilder;
begin
    self._xmlElement.AppendChild(GetDocument().CreateCDATASection(Convert.ToBase64String(value, Base64FormattingOptions.None)));
    Result := self;
end;

method XMLBuilder.Data(value: array of Byte) : XMLBuilder;
begin
    Result := self.Cdata(value);
end;

method XMLBuilder.D(value: array of Byte) : XMLBuilder;
begin
    Result := self.Cdata(value);
end;

method XMLBuilder.Comment(value : String) : XMLBuilder; 
begin
    self._xmlElement.AppendChild(GetDocument().CreateComment(value));
    Result := self;
end;

method XMLBuilder.Cmnt(value : String) : XMLBuilder;
begin
    Result := self.Comment(value);
end;

method XMLBuilder.C(value : String) : XMLBuilder;
begin
    Result := self.Comment(value);
end;

method XMLBuilder.Instruction(target: String; value: String) : XMLBuilder;
begin
    self._xmlElement.AppendChild(GetDocument().CreateProcessingInstruction(target, value));
    Result := self;
end;

method XMLBuilder.Inst(target: String ; value: String) : XMLBuilder;
begin
    Result := self.Instruction(target, value);
end;

method XMLBuilder.I(target: String; value: String) : XMLBuilder;
begin
    Result := self.Instruction(target, value);
end;

method XMLBuilder.Reference(name: String) : XMLBuilder;
begin
    self._xmlElement.AppendChild(GetDocument().CreateEntityReference(name));
    Result := self;
end;

method XMLBuilder.Ref(name: String) : XMLBuilder; 
begin
    Result := self.Reference(name);
end;

method XMLBuilder.R(name: String ) : XMLBuilder;
begin
    Result := self.Reference(name);
end;

method XMLBuilder.Up(steps : Integer ) : XMLBuilder;
var
	currNode: XmlNode;
    stepCount: Integer;

begin
	currNode  := XmlNode(self._xmlElement);
    stepCount := 0;

    while (currNode.ParentNode <> nil) and (stepCount < steps) do begin
    	currNode := currNode.ParentNode;
        stepCount := stepCount + 1;
    end;    
   
    Result := new XMLBuilder(XmlElement(currNode), nil);
end;

method XMLBuilder.Up() : XMLBuilder;
begin
    Result := self.Up(1);
end;

method XMLBuilder.ToWriter(writer: XmlTextWriter);
begin
    self._xmlDocument.WriteTo(writer);
end;

method XMLBuilder.AsString() : String;
var 
    _writer: XmlTextWriter;
    _stringWriter: StringWriter; 
begin
    _stringWriter := new StringWriter();
    _writer := new XmlTextWriter(_stringWriter);
    _writer.Formatting := Formatting.Indented;
    self.ToWriter(_writer);
    _writer.Flush();
    Result := _stringWriter.ToString();
end;

end.