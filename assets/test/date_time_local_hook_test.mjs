import assert from "node:assert/strict";
import test from "node:test";

import DateTimeLocal from "../js/date_time_local.mjs";

function mountHook() {
  const localTime = { value: "" };
  const utcTime = { value: "2026-08-04T12:00:00" };
  const listeners = new Map();

  const el = {
    querySelector(selector) {
      return selector === "input[type=datetime-local]" ? localTime : utcTime;
    },
    addEventListener(type, listener) {
      listeners.set(type, listener);
    },
    removeEventListener(type) {
      listeners.delete(type);
    },
    dispatch(type, target) {
      listeners.get(type)?.({ target });
    },
  };

  const hook = { ...DateTimeLocal, el };
  hook.mounted();

  return { el, hook, localTime, utcTime };
}

test("syncs the hidden UTC value when the datetime control only emits change", () => {
  const { el, localTime, utcTime } = mountHook();
  localTime.value = "2030-01-02T10:30";

  el.dispatch("change", localTime);

  assert.equal(utcTime.value, new Date(localTime.value).toISOString().slice(0, 19));
});
