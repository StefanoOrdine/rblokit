require 'ffi'
require 'pry'

module RbLoKit
  extend FFI::Library

  class LibreOfficeKitClass < FFI::Struct; end
  class LibreOfficeKitDocumentClass < FFI::Struct; end

  class LibreOfficeKit < FFI::Struct
    layout :pClass, LibreOfficeKitClass.ptr
  end

  class LibreOfficeKitDocument < FFI::Struct
    layout :pClass, LibreOfficeKitDocumentClass.ptr
  end

  class LibreOfficeKitDocumentClass < FFI::Struct
    layout :nSize, :size_t,
      :destroy, callback([LibreOfficeKitDocument.ptr], :void),
      :saveAs, callback([LibreOfficeKitDocument.ptr, :string, :string, :string], :int)
  end

  class LibreOfficeKitClass < FFI::Struct
    layout :nSize, :size_t,
      :destroy, callback([LibreOfficeKit.ptr], :void),
      :documentLoad, callback([LibreOfficeKit.ptr, :string], LibreOfficeKitDocument.ptr),
      :getError, callback([LibreOfficeKit.ptr], :string)
  end

  ffi_lib '/usr/lib/libreoffice/program/libmergedlo.so'
  attach_function :libreofficekit_hook, [:string], LibreOfficeKit.ptr
end

lokit = RbLoKit.libreofficekit_hook('/usr/lib/libreoffice/program/')
doc = lokit.values.first.values[2].call(lokit, 'test.odt')
doc.values.first.values[2].call(doc, './test.doc', nil, nil)
