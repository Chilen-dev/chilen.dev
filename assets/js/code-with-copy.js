document.querySelectorAll(".code-with-copy .copy-button").forEach((button) => {
  let revertTimer;
  const tooltip = button.closest(".code-with-copy")?.querySelector(".tooltip");

  button.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(button.dataset.key);
    } catch (error) {
      return;
    }

    button.classList.add("check");
    tooltip?.classList.add("show");
    clearTimeout(revertTimer);
    revertTimer = setTimeout(() => {
      button.classList.remove("check");
      tooltip?.classList.remove("show");
    }, 1500);
  });
});
