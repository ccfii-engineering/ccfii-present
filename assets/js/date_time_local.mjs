const DateTimeLocal = {
  mounted() {
    this.localTime = this.el.querySelector("input[type=datetime-local]");
    this.utcTime = this.el.querySelector("input[type=hidden]");
    this.syncLocalTime();

    this.handleInput = ({ target }) => {
      if (target === this.localTime) this.syncUtcTime();
    };
    this.el.addEventListener("input", this.handleInput);
    this.el.addEventListener("change", this.handleInput);
  },
  updated() {
    this.localTime = this.el.querySelector("input[type=datetime-local]");
    this.utcTime = this.el.querySelector("input[type=hidden]");
    this.syncLocalTime();
  },
  syncLocalTime() {
    if (!this.utcTime.value) {
      this.localTime.value = "";
      return;
    }

    const value = this.utcTime.value.replace(" ", "T").replace(/Z$/, "");
    const date = new Date(`${value}Z`);

    if (!Number.isNaN(date.getTime())) {
      const pad = (part) => String(part).padStart(2, "0");
      this.localTime.value =
        `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}` +
        `T${pad(date.getHours())}:${pad(date.getMinutes())}`;
    }
  },
  syncUtcTime() {
    if (!this.localTime.value) {
      this.utcTime.value = "";
      return;
    }

    const date = new Date(this.localTime.value);

    if (!Number.isNaN(date.getTime())) {
      this.utcTime.value = date.toISOString().slice(0, 19);
    }
  },
  destroyed() {
    this.el.removeEventListener("input", this.handleInput);
    this.el.removeEventListener("change", this.handleInput);
  },
};

export default DateTimeLocal;
