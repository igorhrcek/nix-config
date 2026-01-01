final: prev: {
  python313 = prev.python313.override {
    packageOverrides = pyfinal: pyprev: {
      llm = pyprev.llm.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
  };
  python313Packages = final.python313.pkgs;
}

